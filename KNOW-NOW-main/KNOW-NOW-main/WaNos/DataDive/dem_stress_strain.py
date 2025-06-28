import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os

import yaml

''' Read the configuration file and set the parameters'''

with open('rendered_wano.yml') as file:
    wano_file = yaml.full_load(file)



# Importing csv-file, calculation of stress and strain, removing of unnecessary columns
def evalForces(file, contactStress):
    
    with open('forces_inputs.yml') as file:
        Liggghts_inputs = yaml.full_load(file)

    selected_columns = ["t","Fz","topwall","bottomwall"]

    # Existing DataFrame operations
    # Creating a DataFrame from the dictionary, selecting only the specified columns
    mydf = pd.DataFrame(Liggghts_inputs, columns=selected_columns)
    #mydf = pd.read_csv(file, sep=",", decimal=".")
    mydf["stressMPa"] = mydf["Fz"] / 400e6
    mydf = mydf.drop(mydf[mydf["stressMPa"] < contactStress].index)
    mydf["thickness"] = mydf["topwall"] - mydf["bottomwall"]
    initThick = mydf["thickness"].iloc[0]
    mydf["strain"] = (initThick - mydf["thickness"]) / initThick

    to_drop = ['Fz', 'topwall', 'bottomwall', 'thickness']
    mydf = mydf.drop(columns=to_drop)

    # Convert DataFrame to dictionary
    data_dict = mydf.to_dict(orient='list')

    

    data_dict = {**Liggghts_inputs, **data_dict}

    # Write to YAML file
    with open('datadive_results.yml', 'w') as file:
        yaml.dump(data_dict, file)

    return mydf

# plot a simple stress-stress-curve of one dataset
def plotCurve(args):
    plt.figure("stress-strain-curve") 
    plt.scatter(args["strain"], args["stressMPa"])
    plt.xlabel("strain")
    plt.ylabel("stress (MPa)")
    plt.ylim(bottom=0)
    plt.xlim(left=0)
    plt.grid(True)
    plt.savefig('stress-strain-curve')
    #return plt.show()

# write csv-file from dataFrame
# def writeCSV(args, filename):
#     return args.to_csv(filename, sep = "\t")

file_name = "forces_inputs.yml"
workflowResult= evalForces("forces.csv", float(wano_file["contact pressure"]))
plotCurve(workflowResult)
#writeCSV(workflowResult, "results.txt")
#workflowResult


