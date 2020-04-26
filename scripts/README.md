# Submitting docking jobs
* Create a directory (say, `docked_proteins`) and put the config file inside. A sample config file looks like this:
```
receptor = /scratch/03864/suman1/COVID19/COVID19DDC/targets/helicase/MERS2_18AB/MERS2_18_A.pdbqt

center_x = -6.0
center_y = -39.0
center_z = 9.0

size_x = 24
size_y = 24
size_z = 24
```
* Run `for dir in $(ls -d /scratch/02875/docking/ligands/Enamine-HTSC/*/); do echo "./dock.sh docked_proteins docked_proteins/config.txt ${dir}"; done > parralel_dock_commands.sh` to create a launcher job file that would go each of the subdirectories of the ligands collection and create a command for writing docking commands
* Run ` parralel_dock_commands.sh` using launcher. `dock_*` files will be created inside of `docked_proteins`
* Merge those files using `cat docked_proteins/dock_* > docked_proteins/dock.sh`. Once done, `dock_*` files can be deleted
* Now submit a launcher job using the file `docked_proteins/dock.sh`


`docked_proteins/results` directory will have the files containing the scores. To get the top ligands and scores, do the following:

* Merge all the files of `docked_proteins/results` using `cat docked_proteins/results/run_* > docked_proteins/results/runs`
* Sort `sort -t, -nk2 docked_proteins/results/runs > docked_proteins/scores`
