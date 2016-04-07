# Hbx Documents
This is a mongodb based document storage. It uses the [GridFS] (http://docs.mongodb.org/manual/core/gridfs/). 
Currently the store is used for 1095A PDF files but it is a generic file storage and can support other documents too.

## REST API
### File
- GET /new
- POST /files
- GET /files

### MemberDocument
- POST /member_documents
- POST /member_documents/:id

## Load 1095A 
- DataLoaderFor1095A.run() - this uses the script hbx_documents/scripts/load_data.rb
- It will read all the files in File.join(Padrino.root, "test_data/**", "*.pdf")
- For each file it will create the StoredFile and MemberDocument

## Delete 1095A
- Delete MemberDocument
- Delete StoredFile

## Batch Upload 1095As
- Plug into DCHBX LAN
- Place all the 1095A pdfs in ```/test_data/```
- run ```padrino r scripts/load_data.rb -e production``` 
