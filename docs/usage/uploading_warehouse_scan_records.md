# Uploading Warehouse Scan Records

There are two ways to upload new warehouse scans from the robots:
- Manually import the JSON data using a rake task
- Use the POST endpoint for automatic uploads

## Rake task
For debugging purposes, it is possible to manually upload a JSON scan directly to the application. To do this:
1. Place the scans you wish to upload into the `lib/tasks/data/scans` directory. Note that the directory already contains an example scan for demonstration purposes.
2. Run the following rake command: `rake debug:import_scans`

You should see the following output:
```
% rake debug:import_scans

Importing scan from lib/tasks/data/scans/scan1.json... Done.
Finished importing 1 scan.
```

This indicates that a scan has been uploaded successfully, and will be available as if it was sent by a robot using the POST endpoint below.

## POST endpoint
#### Request
When running, the application exposes a `POST` endpoint at the following URL:
`POST /scans`
which accepts the following parameters:
```
{ 
    scan: 
    { 
        file: [The file to be uploaded]
    } 
}
```

The file must be sent as standard multipart form data, and must be a JSON file containing the required Robot scan data. Describing the schema of the JSON input format is outside the scope of this document. 

#### Response
##### Success
If the scan was successfully uploaded, you will recieve a `201 Created` response.
##### Failure
If something went wrong, you will recieve a `500 Internal Server Error` response, and more information about the error in the following format:
```
{
    errors: "Human-readable message."
}
```
