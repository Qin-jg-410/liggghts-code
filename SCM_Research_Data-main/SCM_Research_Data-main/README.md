# ResearchData
In this research a newly developed SCM method is compared to 2D shell mesh for representing repeating porous boundaries.
The main incentive for developing this method was to reduce the computation time of such boundaries.
The mentioned novel SCM implementation can be found at: https://github.com/DamlaSerper/SCM.
Link to the journal article:

**Contributing Authors:**
- MSc. Damla Serper (Aalto Univeristy, Finland) '*corresponding author*'
- Dr. Kevin Hanley (University of Edinburgh, UK)
  
Below you can find the file structure of the folders within this repository.

## Centrifugation 
### Mesh
#### INPUT
Simulations are run on supercomputer Puhti of CSC, Finland, using 40 cores on a single node and is allocated 3 GB of memory. These simulations are run on small partition since all were completed under 3 days.
- b.mesh: Bash script for running batch job on supercomputer.
- lmp.puhti: Executable file of LIGGGHTS-PFM that is compiled on the supercomputer Puhti.
- dump.atom_info_1: Information regarding the initial location of the particles with various radii.
- in.cent_mesh_walls: The script used for giving LIGGGHTS-PFM commands to execute

mesh files: check https://github.com/DamlaSerper/Parameterized_Centrifugal_Filter for how these are generated.

- bottom_disk.stl 
- bot_cyl.stl
- cone.stl
- in_cap.stl
- in_cyl.stl
- top_cyl.stl
- top_disk.stl
- trial_2.stl: representing the filter mesh walls in a 2D thin shell manner
#### OUTPUT
- dump.atom_info_ac_2:12309720: Particle locations at each 32 394 timesteps from 2 to 12 309 720 timesteps.
- log.liggghts: Log file of the simulation, created by LIGGGHTS-PFM.
- slurm_21912798: Slurm file of the submitted batch job with the ID 21912798, generated on supercomputer Puhti.
- filter_mesh_scaled1.stl: The computatinal mesh representing the physical mesh wall is scaled within the LIGGGHTS-PFM script, this file shows the scaled version of this mesh in .stl format at timestep 1.
- numatoms.zip: This contains numatoms.txt file, which writes out the number of particles within the system every step.
### SCM
#### INPUT
Consists of the equivalent files to Mesh, excluding the trial_2.stl.
#### OUTPUT
Consists of the equivalent files to Mesh, excluding the filter_mesh_scaled1.stl.
### Prep_and_Results
- CalcPrimitive.mlx: This MATLAB script helps calculating the function parameters of SCM from the physical dimensions of the centrifuge, see https://github.com/DamlaSerper/Parameterized_Centrifugal_Filter to understand more about the centrifuge dimensions.
- Prep_and_Results_Centrifugation.xlsx: This file shows the results of Mesh and SCM comparison in terms of computation duration and particle retention.  
#### Images_and_Videos
These images and videos are created using Ovito, ffmpeg and ImageMagick.
- Left/Top.mp4: Shows the animations of Mesh and SCM cases side by side, from left and top point of view respectively.
- Mesh/SCM_Left/Top.mp4: Shows the animation of Mesh or SCM case from left or top point of view.
- Mesh/SCM_Left/Top_1/190/381.png: Image files of Mesh or SCM case from left or top point of view at 1st, 190th or 381th frame. Frame 1 corresponds to timestep 2, while 190 corresponds to 6 122 466 and 381 corresponds to 12 309 720.
- Left/Top_2/3.png: 2 by 2 and 3 by 3 stacked image comparison of Mesh and SCM cases from left or top point of view. For 2 by 2 frames 2 and 381 are used, while for 3 by 3 frames 2, 190 and 381 are used.
## Calibration
### Mesh
#### INPUT
Simulations are run using mpirun -np 1 lmp_fedora < in.file on the local computer using a single processor.
- lmp.fedora: Executable file of LIGGGHTS-PFM that is compiled on the local computer with Linux operating system.
- dump.atom_info_1: Information regarding the initial location of the particles with various radii.
- in.cal_mesh_walls_30X: The script used for giving LIGGGHTS-PFM commands to execute.
- cal_mesh.stl: check Calibration/Prep_and_Results/gmsh_cal.mesh.geo to see how the flat rectangular mesh is generated.
#### OUTPUT
- dump.atom_info_ac_5000:120000: Particle locations at each 5 000 timesteps from 5 000 to 120 000 timesteps.
- log.liggghts: Log file of the simulation, created by LIGGGHTS-PFM.
- meshwallscaled1200001.stl: This file shows mesh in.stl format at timestep 120 001.
- numatoms.txt: Contains the number of particles within the system, written out on every step.
### Run1:24
There were 24 calibration experiments, the details of each case can be checked from Calibration/Prep_and_Results/Prep_and_Results_Calibration.mlx.
#### INPUT
Consists of the equivalent files to Mesh, excluding the cal_mesh.stl.
#### OUTPUT
Consists of the equivalent files to Mesh, excluding the meshwallscaled1200001.stl.
### Prep_and_Results
- PACCCK_Calibration.mlx: This MATLAB script creates an initial particle packing for the calibration runs.
- gmsh_cal_mesh.geo: This GMSH script creates a flat rectangular filter mesh with square pores.
- Prep_and_Results_Calibration.mlx: This Excel file contains the prelliminary calculations and results of the calibration study.
