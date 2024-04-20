require 'debug'
require './index_rst_class.rb'

Dir.chdir("../lin_source/Documentation"); # work wif argv
allIndexRst=Dir.glob("**/index.rst");
allRstFiles=Dir.glob("**/*.rst");
allGloFiles=Dir.glob("**/*");
tabs = ["input/joydev/index.rst","media/cec-drivers/index.rst","media/dvb-drivers/index.rst","media/v4l-drivers/index.rst"];

allIndexObj = []; # container for IndexRst Objects
# path (from Documentation Folder as root folder) => contents
allRstAry = [];

allRstFiles.each{ |item|  h={}; h.store("path", item); h.store("content", File.open(item,'r').read() );
  allRstAry.append(h);
}

IndexRst::class_variable_set(:@@rstFiles,allRstAry);

allIndexRst.each{ |item|  h={}; h.store("path", item); h.store("content", File.open(item,'r').read() );
  h["content"].gsub!("\t","   ") if tabs.include?(h["path"]);
  allIndexObj.append(IndexRst.new(h));
}

t0=allIndexObj.first; #PIC/endpoint/index flat
t1=allIndexObj[1]; # PCI/index
t80 =allIndexObj[80]; #index.rst
t82 =allIndexObj[82]; #inputdevices
t84=allIndexObj[84]; # joydev tabs
t15 = allIndexObj[15]; #adminGuide
t118= allIndexObj[118]; #sh/index mainIndex include this

#allindexobj size 152
#21 not ready after init
tt = allIndexObj.select{|item| item.availableAsString == false}

#binding.break;

tt[0].constructStringPostInit
tt[1].constructStringPostInit
tt[2].constructStringPostInit
tt[3].constructStringPostInit
tt[4].constructStringPostInit
tt[5].constructStringPostInit
tt[6].constructStringPostInit
tt[7].constructStringPostInit
#master tt[8].constructStringPostInit
tt[9].constructStringPostInit
tt[10].constructStringPostInit
tt[11].constructStringPostInit
tt[12].constructStringPostInit
tt[13].constructStringPostInit
tt[14].constructStringPostInit
tt[16].constructStringPostInit
tt[17].constructStringPostInit
tt[18].constructStringPostInit
tt[19].constructStringPostInit
tt[20].constructStringPostInit

tt[15].constructStringPostInit
tt[8].constructStringPostInit

output = File.open("output.txt",'w');
output.write(tt[8].asString);

#binding.break;
#ttt = allIndexObj.select{|item| item.availableAsString == false}

#ttt[0].dependsOn.each {|i| pp i; ttt[0].getContentFromPath(ttt[0].postInit2Path(i)); }
#binding.break;
