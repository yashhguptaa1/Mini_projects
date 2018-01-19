import os
#https://docs.python.org/3/library/os.html
#Each website you crawl is a seperate folder
#Each website you crawl has two file :queue& crawled

def create_project_dir(directory):
    if  not os.path.exists(directory):
        print('Creating project ' + directory)
        #print(os.path)
        os.makedirs(directory)

#create_project_dir('thenewboston')

def create_data_files(project_name,base_url): #starting point
    queue= project_name + '/queue.txt'#list of websites waiting to be crawled
    crawled=project_name + '/crawled.txt'
    if not os.path.isfile(queue):
        write_file(queue,base_url)
    if not os.path.isfile(crawled):
        write_file(crawled,'')#empty file name othervise it will considerwe crawled the base url which we didnt

#create a new file
def write_file(path,data):
    with open(path, 'w') as f:
        f.write(data)

#    f=open(path,'w')
  #  f.write(data)
 #   f.close()

#create_data_files('check1','https://thenewboston.com/')

# called to add data on existing file/whenever new link is added
def append_to_file(path, data):
    with open(path,  'a') as file:
        file.write(data + '\n')

#Delete the contents of a file and convert set to file
#https://stackoverflow.com/questions/1369526/what-is-the-python-keyword-with-used-for
#https://stackoverflow.com/questions/3012488/what-is-the-python-with-statement-designed-for
#https://stackoverflow.com/questions/13886168/how-to-use-the-pass-statement-in-python
#https://www.geeksforgeeks.org/how-to-write-an-empty-function-in-python-pass-statement/

def delete_file_contents(path):
    open(path, 'w').close()
                        #with open(path,'w'):
     #   pass

#read a file and convert each line to set items because set stored in RAM thus easily accessible
#https://stackoverflow.com/questions/23051062/open-files-in-rt-and-wt-modes
#https://www.geeksforgeeks.org/sets-in-python/
def file_to_set(file_name):
    results = set()
    with open(file_name, 'rt') as f:
        for line in f:
            results.add(line.replace('\n', ''))#line is read as :url + \n,,\n can be removed as done
        return results

#Iterate through a set ,each item will be a new line in the file
#https://www.geeksforgeeks.org/sorted-function-python/
#def set_to_file(links,file):
 #   delete_file_contents(file)
  #  for link in sorted (links):
   #     append_to_file(file,link)


def set_to_file(links, file_name):
    with open(file_name,"w") as f:
        for l in sorted(links):
            f.write(l+"\n")
