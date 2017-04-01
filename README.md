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
- Place all the 1095A pdfs in ```/test_data/```. Create this directory under RAILS_ROOT.
- run ```padrino r scripts/load_data.rb -e production``` 

## License

The software is available as open source under the terms of the MIT License (MIT)

Developed and managed by IdeaCrew, Inc. and HBX

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above attribution notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
