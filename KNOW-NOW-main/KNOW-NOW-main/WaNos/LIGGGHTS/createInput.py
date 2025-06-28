
import yaml, ast, tarfile, shutil, os


# Here's an improved version of the create_tar_and_delete function with added documentation and error handling

def create_tar_and_delete(folders=None):
    """
    Creates tar archives of the given folders and then deletes the folders.

    Parameters:
    folders (list of str): A list of folder names to be archived and deleted.
                           If None, defaults to ['stl', 'vtk'].
    """
    if folders is None:
        folders = ['stl', 'vtk']
    
    for folder in folders:
        try:
            tar_filename = f"{folder}.tar"
            
            # Check if the folder exists
            if not os.path.exists(folder):
                print(f"Folder '{folder}' does not exist, skipping.")
                continue
            
            # Create the tar file
            with tarfile.open(tar_filename, 'w') as tar:
                tar.add(folder)
                print(f"Tar file created for folder '{folder}'.")
            
            # Delete the folder
            shutil.rmtree(folder)
            print(f"Folder '{folder}' deleted.")
            
        except Exception as e:
            print(f"An error occurred while processing '{folder}': {e}")
            continue

    print("All specified folders have been processed.")


''' Read the configuration file and set the parameters'''

with open('rendered_wano.yml') as file:
    wano_file = yaml.full_load(file)


# declaration of variables

pairMod = 'hertz tangential history '
absNumber = int(wano_file["total number of hard particles"]) #4000
totalNum = absNumber*1.1
totalPol = totalNum-absNumber
youngMod1 = 10e9
youngMod2 = 10e6
poisson1 = 0.5
poisson2 = 0.3

# Reading the box size from the configuration file
box_size = wano_file['Class']
# Removing leading and trailing spaces and double quotes
cleaned_value = box_size.strip().strip('"')
# Converting the cleaned string to a list using ast.literal_eval
list_value = ast.literal_eval(cleaned_value)

size1, size2, size3, size4, size5 = list_value[0]
frac1, frac2, frac3, frac4, frac5 = list_value[1]

# size5 = float(wano_file["size class 5"])
# size4 = float(wano_file["size class 4"])
# size3 = float(wano_file["size class 3"])
# size2 = float(wano_file["size class 2"])
# size1 = float(wano_file["size class 1"])

# frac5 = float(wano_file["fraction class 5"])
# frac4 = float(wano_file["fraction class 4"])
# frac3 = float(wano_file["fraction class 3"])
# frac2 = float(wano_file["fraction class 2"])
# frac1 = float(wano_file["fraction class 1"])

ceraFrac5 = (absNumber*frac5)/totalNum
ceraFrac4 = (absNumber*frac4)/totalNum
ceraFrac3 = (absNumber*frac3)/totalNum
ceraFrac2 = (absNumber*frac2)/totalNum
ceraFrac1 = (absNumber*frac1)/totalNum
polyFrac = totalPol/totalNum

maxForce = -40000000000
velPlate = float(wano_file["velocity of pressing plate"]) #0.4
timeSteps = int(wano_file["timesteps"])
dumprate = int(wano_file["dumprate trajectory"])
dumprate_vis = int(wano_file["dumprate vtk and stl"])
my_string = '"${time},${fz},${topwall},${bottomwall}"'


def createLIGGGHTS(fileName):
    with open(fileName, "w") as code:
        # write LIGGGTHTS code with individul parameters
        code.write(f"""### Build Simulation
    # Specify what we are simulating

    atom_modify     map array #not important command
    boundary        p p p #periodic boundary condition
    newton          off
    communicate     single vel yes
    units           si
    atom_style      sphere
    hard_particles  yes 
    region          reg block -13 13 -13 13 -5 30 units box #creation of box size of simulation
    create_box      4 reg 
    neighbor        0.002 bin
    neigh_modify    delay 0\n

    # Material properties\n

    fix             m1 all property/global youngsModulus peratomtype {youngMod1} {youngMod2} 11e9 11e9 
    fix             m2 all property/global poissonsRatio peratomtype {poisson1} {poisson2} 0.5 0.5     
    fix             m3 all property/global coefficientRestitution peratomtypepair 4  0.9 0.3 0.9 0.3 0.3 0.07 0.3 0.3 0.9 0.3 0.5 0.5 0.3 0.3 0.5 0.5 
    fix             m4 all property/global coefficientFriction peratomtypepair 4 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5\n      

    # Pair style with contact model
    pair_style      gran model {pairMod}

    pair_coeff       * *   
    timestep        0.0001


    #defining two atom types for polymer and ceramic 
    group           ceramic type 1
    group           polymer type 2\n

    fix             gravi all gravity 9.81 vector 0.0 0.0 -1.0 #gravity for insertion


    # Insertion of particles

    fix             pstclass5 ceramic particletemplate/sphere 15485867 atom_type 1 density constant 4000 radius constant {size5}
    fix             pstclass4 ceramic particletemplate/sphere 32452843 atom_type 1 density constant 4000 radius constant {size4}
    fix             pstclass3 ceramic particletemplate/sphere 32452867 atom_type 1 density constant 4000 radius constant {size3}
    fix             pstclass2 ceramic particletemplate/sphere 49979687 atom_type 1 density constant 4000 radius constant {size2}
    fix             pstclass1 ceramic particletemplate/sphere 49979693 atom_type 1 density constant 4000 radius constant {size1}
    fix             pstpolymer polymer particletemplate/sphere 67867967 atom_type 2 density constant 4000 radius constant 0.2
    fix             pdd1 all particledistribution/discrete 67867979 6 pstclass5 {ceraFrac5} pstclass4 {ceraFrac4} pstclass3 {ceraFrac3} pstclass2 {ceraFrac2} pstclass1 {ceraFrac1} pstpolymer {polyFrac}
    region          press_die block -9.5 9.5 -9.5 9.-5 0.5 24.5 units box
    fix             ins all insert/rate/region seed 15485863 distributiontemplate pdd1 nparticles {totalNum} particlerate {totalNum} insert_every 1000 overlapcheck yes region press_die ntry_mc 10000
    run             20000
    
    
    # Apply nve integration to all particles
    fix             integr all nve/sphere 

    
    # Pressing plates
    fix             cad1 all mesh/surface/stress/servo file bottom_wall.stl type 3 com 0 0 -1 ctrlPV force axis 0 0 1 vel_max 0.01 
    fix             cad2 all mesh/surface/stress/servo file top_wall.stl type 4 com 0 0 26 ctrlPV force axis 0 0 1 target_val {maxForce} vel_max {velPlate} kp 5. #pushing down the top wall with force
    fix             cad3 all mesh/surface file Matrize.stl type 4   
    fix             meshwalls all wall/gran model {pairMod}  mesh n_meshes 3 meshes cad1 cad2 cad3  #applying contact model and to walls and particles\n

    # Let particles fall down
    dump            dmpins all custom 500 post/dump.insertion id type x y z radius
    run             30000   

    # Definition of output variables
    variable        time equal step*dt
    variable        fz equal f_cad2[3]
    variable        topwall equal f_cad2[9]
    variable        bottomwall equal f_cad1[9] \n

    # Dump forces
    dump            forces all mesh/vtk {dumprate_vis} vtk/dumpI*.vtk output interpolate id stress stresscomponents
    #dump           dmpvtk all custom/vtk 1000 post6/dump*.myforce.vtu id type x y z radius
    fix             forceslog all print 25 {my_string} file forces.csv title "t,Fz,topwall,bottomwall" screen no

    # Creating imaging information
    dump           dumpstl all stl {dumprate_vis} stl/dump*.stl
   
    # Dumping trajectory of particles
    dump            dmpcomp all custom {dumprate} dump.compression id type x y z radius

    run {timeSteps}""")

createLIGGGHTS("workflow.inp")

create_tar_and_delete()
