import xml.etree.ElementTree
from datetime import datetime

# Open original file
et = xml.etree.ElementTree.parse('base/driver.xml')
root = et.getroot();
version = root.find('version')
modified = root.find('modified')
version.text = str(int(version.text)+1);
modified.text = datetime.now().strftime('%m/%d/%Y %I:%M %p')
et.write('base/driver.xml')
