import requests
import yaml
import os

sources_list = []

# Function to fetch metadata, modify it, and generate a YAML configuration
def fetch_metadata_and_generate_yaml(dataset_name):
    try:
        # Assuming the dataset_name is part of the URL
        url = f"{dataset_name}/$metadata"
        headers = {
            'accept' : 'application/xml' 
        }
        
        # Fetch the metadata
        #response = requests.get(url, headers=headers)
        #print(url)
        #print(response.request.headers)
        #print(response.headers)
        if response.status_code == 200:
            metadata = response.text
            
            # Replace 'Edm.DateTime' with 'Edm.DateTimeOffset'
            modified_metadata = metadata.replace('"Edm.DateTime"', '"Edm.DateTimeOffset"')
            modified_metadata = metadata
            
            # Save the metadata file locally
            dataset_id = dataset_name.split('/')[-1]  # Extract dataset name for filenames
            dataset_id = dataset_id.replace(".", "")
            metadata_filename = f"{dataset_id}_metadata.xml"
            with open(metadata_filename, 'w') as file:
                file.write(modified_metadata)
            
            print(f"Metadata for {dataset_name} saved as {metadata_filename}")
            
            # Get the absolute path of the metadata file for the YAML configuration
            metadata_file_path = os.path.abspath(metadata_filename)
            
            # Generate YAML configuration for GraphQL Mesh, pointing to the local metadata file
            source_data = {
                        "name": f"CBS{dataset_id}",  # Use the dataset ID as the source name
                        "handler": {
                            "odata": {
                                "endpoint": dataset_name,  # OData service URL
                                "source": metadata_file_path,  # Local file path to the metadata
                                "expandNavProps": True
                            }
                        },
                         "transforms" : [
                            { "prefix" : {
                                "value" : f"CBS{dataset_id}",
                                "includeRootOperations": True
                               }
                            }
                        ]
                        
                    }
            sources_list.append(source_data)

            print(f"YAML configuration for {dataset_name} saved.")
        else:
            print(f"Failed to fetch metadata for {dataset_name}. Status code: {response.status_code}")
            print(response.text)
            
    except Exception as e:
        print(f"An error occurred while processing {dataset_name}: {e}")

# Read the file line by line
with open("datasets.txt", "r") as file:
    dataset_names = file.readlines()

# Strip any extra spaces or newlines from each line
dataset_names = [name.strip() for name in dataset_names]

loc = {
    "name": "LOC" ,  # Use the dataset ID as the source name
    "handler": {
      "openapi": {
        "endpoint": "https://api.pdok.nl/bzk/locatieserver/search/v3_1/",  
        "source": "./locatieserver_openapi.yaml",
        "ignoreErrorResponse" : False
      }
    },
    "transforms" : [
       { "prefix" : {
         "value" : "LOC",
         "includeRootOperations": True
       }
    }
   ]
}

cbs = {
    "name" : "CBS",
    "handler": {
      "openapi": {
        "source": "./cbsopenapi.json",
        "endpoint": "https://www.cbs.nl/odata/v1/",
        "ignoreErrorResponses": False,
        "operationHeaders": {
          "Content-Type": "application/json"
        }
      }
    },
    "transforms": [
      { "prefix": {
          "value": "CBS",
          "includeRootOperations": True
      }
      }
    ]
}
sources_list.append(loc) 
sources_list.append(cbs)
# Process each dataset
for dataset in dataset_names:
    fetch_metadata_and_generate_yaml(dataset)

yaml_data = {
   "serve": {
      "port" : 80,
      "browser": False,
      "playground" : True,
      "endpoint": "/mesh",
      "playgroundTitle": "CBS Demo Playground"
   },
   "sources": sources_list
}

# Save YAML configuration
yaml_filename = f".meshrc.yaml"
with open(yaml_filename, 'w') as yaml_file:
    yaml.dump(yaml_data, yaml_file, default_flow_style=False)
