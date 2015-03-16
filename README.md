# Hbx Documents
This is a mongodb based document storage. It uses the [GridFS] (http://docs.mongodb.org/manual/core/gridfs/). 
Currently the store is used for 1095A PDF files but it is a generic file storage and can support other documents too.

## Load 1095A 
- DataLoaderFor1095A.run() - this uses the script hbx_documents/scripts/load_data.rb
- It will read all the files in File.join(Padrino.root, "test_data/**", "*.pdf")
- For each file it will create the StoredFile and MemberDocument

## Deleting 1095A
- Delete MemberDocument
- Delete StoredFile
