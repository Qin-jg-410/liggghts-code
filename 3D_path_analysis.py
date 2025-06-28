import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D # 用于三维绘图
import re
import glob
import os # 用于文件路径操作

filepath = r"F:\liggghts-code\LIGGGHTS_BE-main\LIGGGHTS_BE-main\examples\LIGGGHTS\Benchmarks\mpi_mesh_scalability\it"
def parse_vtk_file(filepath):
    """
    解析LIGGGHTS生成的VTK文件，提取颗粒的ID和XYZ坐标。

    Args:
        filepath (str): VTK文件的路径。

    Returns:
        dict: 一个字典，键为颗粒ID，值为 (x, y, z) 坐标元组。
              如果文件解析失败或不包含所需数据，返回None。
    """
    particle_data = {}
    points = []
    ids = []
    num_points = 0
    reading_points = False
    reading_ids = False

    try:
        with open(filepath, 'r') as f:
            lines = f.readlines() # 读取所有行，方便处理POINTS和FIELD数据块

        # 查找POINTS块
        points_start_line = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('POINTS'):
                parts = line.split()
                num_points = int(parts[1])
                points_start_line = i + 1 # POINTS数据从下一行开始
                break
        
        if points_start_line == -1:
            print(f"Warning: No 'POINTS' block found in {filepath}.")
            return None

        # 读取POINTS数据
        current_points_read = 0
        for i in range(points_start_line, len(lines)):
            line = lines[i].strip()
            if not line: # 跳过空行
                continue
            
            coords_str = line.split()
            try:
                coords = list(map(float, coords_str))
                for j in range(0, len(coords), 3):
                    points.append(tuple(coords[j:j+3]))
                    current_points_read += 1
                if current_points_read >= num_points:
                    break # 已经读取了所有点
            except ValueError: # 如果遇到非数字行，可能是下一个数据块的开始
                break


        # 查找id数据块
        id_start_line = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('FIELD FieldData'):
                # 找到 FIELD FieldData 后，继续寻找 id 1 num_points int
                for j in range(i + 1, len(lines)):
                    if lines[j].strip().startswith('id 1'):
                        id_start_line = j + 1
                        break
            if id_start_line != -1:
                break
        
        if id_start_line == -1:
            print(f"Warning: No 'id' array found in FIELD FieldData in {filepath}.")
            return None

        # 读取ID数据
        current_ids_read = 0
        for i in range(id_start_line, len(lines)):
            line = lines[i].strip()
            if not line: # 跳过空行
                continue
            
            current_ids_str = line.split()
            try:
                current_ids = list(map(int, current_ids_str))
                ids.extend(current_ids)
                current_ids_read += len(current_ids)
                if current_ids_read >= num_points:
                    break # 已经读取了所有ID
            except ValueError: # 如果遇到非数字行，可能是下一个数据块的开始
                break


        # 匹配ID和坐标
        if len(points) == num_points and len(ids) == num_points:
            for i in range(num_points):
                # 确保ID存在且不重复，并将其与点数据关联
                if ids[i] not in particle_data:
                    particle_data[ids[i]] = points[i]
                else:
                    # 如果ID重复，可能是VTK格式解析问题，或者数据本身有问题
                    # 这里选择覆盖，或者可以根据需求记录警告
                    particle_data[ids[i]] = points[i] 
        else:
            print(f"Warning: Data mismatch in {filepath}. Points read: {len(points)}, IDs read: {len(ids)}, Expected: {num_points}")
            return None

    except FileNotFoundError:
        print(f"Error: File not found at {filepath}")
        return None
    except Exception as e:
        print(f"Error parsing {filepath}: {e}")
        return None
        
    return particle_data

def analyze_particle_trajectories(file_pattern, particle_ids_to_analyze):
    """
    分析指定ID颗粒的三维坐标变化情况，并绘制轨迹。

    Args:
        file_pattern (str): VTK文件路径的通配符模式（例如 'post/particles_*.vtk'）。
        particle_ids_to_analyze (list): 包含要分析的颗粒ID的列表。
    """
    all_files = sorted(glob.glob(file_pattern))
    if not all_files:
        print(f"Error: No files found matching pattern '{file_pattern}'. Please check the path and file naming convention.")
        print(f"Current working directory: {os.getcwd()}")
        return

    # 存储每个颗粒的轨迹数据 {particle_id: {'x': [], 'y': [], 'z': []}}
    trajectories = {pid: {'x': [], 'y': [], 'z': []} for pid in particle_ids_to_analyze}
    
    # 存储每个时间步的帧号/索引
    time_steps_indices = []

    print(f"Found {len(all_files)} VTK files. Analyzing trajectories for particles: {particle_ids_to_analyze}")

    for i, filepath in enumerate(all_files):
        print(f"Processing {filepath} (File {i+1}/{len(all_files)})...")
        current_frame_data = parse_vtk_file(filepath)
        
        if current_frame_data is None:
            print(f"Skipping {filepath} due to parsing error.")
            # 为当前帧的所有目标颗粒填充NaN，保持轨迹长度一致
            for pid in particle_ids_to_analyze:
                trajectories[pid]['x'].append(np.nan)
                trajectories[pid]['y'].append(np.nan)
                trajectories[pid]['z'].append(np.nan)
            time_steps_indices.append(i) # 即使跳过，时间步索引也要增加
            continue

        # 将当前文件索引作为时间步（或可以尝试从文件名中提取真实的step号）
        time_steps_indices.append(i) 

        for pid in particle_ids_to_analyze:
            if pid in current_frame_data:
                x, y, z = current_frame_data[pid]
                trajectories[pid]['x'].append(x)
                trajectories[pid]['y'].append(y)
                trajectories[pid]['z'].append(z)
            else:
                # 如果某个颗粒在当前帧不存在，则填充NaN，绘图时会断开连接
                trajectories[pid]['x'].append(np.nan)
                trajectories[pid]['y'].append(np.nan)
                trajectories[pid]['z'].append(np.nan)


    # 绘制三维轨迹
    if not time_steps_indices:
        print("No valid data frames processed to draw trajectories.")
        return

    fig = plt.figure(figsize=(12, 10))
    ax = fig.add_subplot(111, projection='3d') # 创建3D子图

    # 颜色映射，使不同颗粒的轨迹有不同颜色，最多支持 20 种颜色
    colors = plt.cm.get_cmap('tab20', len(particle_ids_to_analyze)) 
    
    for idx, pid in enumerate(particle_ids_to_analyze):
        # 提取有效数据点（非NaN）
        x_coords = np.array(trajectories[pid]['x'])
        y_coords = np.array(trajectories[pid]['y'])
        z_coords = np.array(trajectories[pid]['z'])
        
        valid_indices = ~np.isnan(x_coords) & ~np.isnan(y_coords) & ~np.isnan(z_coords)

        # 仅当有有效数据时才绘制
        if np.any(valid_indices):
            ax.plot(x_coords[valid_indices],
                    y_coords[valid_indices],
                    z_coords[valid_indices],
                    color=colors(idx), # 为每个颗粒分配不同颜色
                    marker='o', # 在数据点处显示圆圈标记
                    markersize=2, # 标记大小
                    linestyle='-', # 连接线的样式
                    linewidth=1, # 线的粗细
                    label=f'Particle {pid}')

    ax.set_xlabel('X Coordinate (m)')
    ax.set_ylabel('Y Coordinate (m)')
    ax.set_zlabel('Z Coordinate (m)')
    ax.set_title(f'3D Trajectories of Particles {min(particle_ids_to_analyze)}-{max(particle_ids_to_analyze)}')
    
    # 自动调整轴的限制，确保轨迹完整显示
    ax.autoscale_view(tight=True) 

    # 将图例放在图外，避免遮挡数据
    ax.legend(loc='center left', bbox_to_anchor=(1.05, 0.5), fontsize='small', ncol=1) 
    plt.tight_layout(rect=[0, 0, 0.95, 1]) # 调整布局以适应图例

    plt.show()

    # 绘制每个颗粒的Z坐标随时间的变化（二维图）
    fig_2d, ax_2d = plt.subplots(figsize=(10, 6))
    
    for idx, pid in enumerate(particle_ids_to_analyze):
        z_coords = np.array(trajectories[pid]['z'])
        valid_indices_2d = ~np.isnan(z_coords)
        
        if np.any(valid_indices_2d):
            # 确保X轴数据与Z坐标数据长度匹配
            x_axis_for_2d_plot = np.array(time_steps_indices)[:len(z_coords)]
            ax_2d.plot(x_axis_for_2d_plot[valid_indices_2d],
                       z_coords[valid_indices_2d],
                       color=colors(idx), # 使用相同颜色
                       label=f'Particle {pid} Z-Coordinate')
    
    ax_2d.set_xlabel('Time Step (Frame Index)')
    ax_2d.set_ylabel('Z Coordinate (m)')
    ax_2d.set_title('Z-Coordinate Change Over Time for Selected Particles')
    ax_2d.legend(loc='best')
    ax_2d.grid(True)
    plt.show()


# --- 主程序部分 ---
if __name__ == '__main__':
    # !!! 重要配置区：请根据您的实际 LIGGGHTS 输出路径和文件命名习惯修改此处 !!!
    #
    # 假设您的 LIGGGHTS 输出 VTK 文件位于 'G:\liggghts\post\' 目录下，
    # 并且文件命名为 'particles_0.vtk', 'particles_1000.vtk', 'particles_2000.vtk' 等。
    # 如果您的文件是 'particles_3100000.txt'，并且没有多帧，
    # 您需要手动复制并重命名文件（例如：复制 particles_3100000.txt 到 post/particles_0.vtk），
    # 或者修改 parse_vtk_file 以处理单个txt文件作为单帧数据。
    # 
    # 示例文件模式：
    # 方式1: 推荐使用原始字符串 (r"") 定义Windows路径
    
    file_pattern = os.path.join(filepath, 'dump*.vtk')
    
    # 方式2: 使用正斜杠 (更通用，Python内部会自动转换)
    # base_liggghts_output_dir = "G:/liggghts/post"
    # file_pattern = os.path.join(base_liggghts_output_dir, 'dump*.vtk')
    
    # 请确保 'post' 目录和其中的VTK文件真实存在！

    # 要分析的颗粒ID范围 (从ID 1 到 100)
    # 请注意：如果您的LIGGGHTS输出中没有这些ID，轨迹将是空的或包含NaN。
    particle_ids_to_analyze = list(range(1,2))

    # 执行分析
    analyze_particle_trajectories(file_pattern, particle_ids_to_analyze)

