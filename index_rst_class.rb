class IndexRst

#sanity check toctree amount same as matchAry.size;
# also fix tabs > \s{3}

  @@captureRegex = /(?<total>(?:\.\.\s{1}toctree\:\:\n{1}(?<directives>(?:\s{3,}\:.+\n{1})*)\n{1}(?<files>(?:\s{3,}.+\n)+))+)/

  @@rstFiles=[]; #[[hash {path:str,content:str}],..]
  #select {|i| i["path"]==}
  attr_accessor :path; #path location of this index.rst file
  attr_accessor :inFolderFiles; # ary with files in same folder
  attr_accessor :inFolderNonRst; # ary with non rst files in same folder
  attr_accessor :subFolderRefs; # ary containing refs to subfolder "/" in ref
  attr_accessor :includes; # any include directives
  attr_accessor :asString; # for building final masterfile
  attr_accessor :matchAry; #
  attr_accessor :referencedBy; # from which index.rst file referenced
  # :notinindexrst_butinfolder

  attr_accessor :location; # data["path"] split by /
  attr_accessor :sphinxScopeName # path without .rst ending
  attr_accessor :content; # for initialize
  attr_accessor :dependsOn; # matchData[files]
  attr_accessor :dependsOnIndexes;
  attr_accessor :availableAsString; # can be used for masterDoc

  def showPaths()
    ary = [];
    @@rstFiles.each{|i| ary.append(i["path"])}
    return ary;
  end
  def fillInFolderFiles()
    @inFolderFiles = Dir.glob("#{@location.join('/')}/*");
    @inFolderFiles = Dir.glob("#{@location.join('/')}*") if @location.size() == 0
    # for main ["index.rst"] index: 80
  end
  def fillDependsOn()
    @matchAry.each {|md| @dependsOn.append(md["files"].split()) if md["files"]; }
    @dependsOn.flatten!;
    @dependsOnIndexes = @dependsOn.select{|i| i.include?("index")};
  end
  def matchDataAry(text)
    ary = [];
    matchData0=@@captureRegex.match(text);
    if matchData0
      ary.append(matchData0)
      while true
        matchData1 = @@captureRegex.match(matchData0.post_match)
        ary.append(matchData1) if matchData1
        matchData0 = matchData1; matchData1 = nil;
        break unless matchData0
      end
    else # just give text back
      ary.append(text)
    end
    return ary;
  end
  def postInit2Path(fromToc)
    return "RCU/index" if fromToc=="../RCU/index"
    fromToc.gsub!(".rst","");
    subIndex = fromToc.include?("/index")
    p = "#{@location.join('/')}/#{fromToc}.rst";
    p = "#{@location.join('/')}#{fromToc}.rst" if @location.size==0
    p.gsub!(".rst","") if subIndex
    return p;
  end
  def sphinxScope2Path(fromToc)
    pp "#{fromToc} in #{@location}" if fromToc.include?(".rst")
    fromToc.gsub!(".rst","");
    p = "#{@location.join('/')}/#{fromToc}.rst";
    p = "#{@location.join('/')}#{fromToc}.rst" if @location.size==0
    return p;
  end
  def getContentFromPath(path)
    out = @@rstFiles.select{|item| item["path"] == path};
    pp out if out.size() > 1
    pp path unless out.size();
    return out.first["content"];
  end
  def constructStringPostInit
    return @asString if @availableAsString
    output = "";
    @matchAry.each {|md| filesAry=md["files"].split();
      output.concat(md.pre_match);
      filesAry.each{|f|
        output.concat(getContentFromPath(  postInit2Path(f) ));
      }
    }
    output.concat(@matchAry.last.post_match);
    @asString = output;
    @availableAsString = true;
    h={}; h.store("path", @sphinxScopeName); h.store("content", @asString);
    @@rstFiles.append(h);
  end
  def constructString
    output="";
    @matchAry.each {|md| filesAry=md["files"].split();
      output.concat(md.pre_match);
      filesAry.each{|f| output.concat( getContentFromPath(sphinxScope2Path(f)) );}
    }
    output.concat(@matchAry.last.post_match);
    return output;
  end
  def constructStringAllWildcard #input/devices/index.rst
    output = "";
    filesToInclude = @inFolderFiles.each.to_a;
    filesToInclude.delete(@sphinxScopeName+".rst");
    output.concat(@matchAry.first.pre_match);
    filesToInclude.each {|f| output.concat(getContentFromPath(f))}
    output.concat(@matchAry.first.post_match);
    @asString = output;
    @availableAsString = true;
  end
  def initialConstructString
    cond0 = @dependsOnIndexes.size == 0;
    cond1 = !(@dependsOn.include?("*"));
    cond2 = @dependsOn.size()>0 ;
    if cond0 && cond1 && cond2
      @asString = constructString();
      @availableAsString = true;
    end
    if !cond1 # #input/devices/index.rst
       constructStringAllWildcard();
    end
    if @sphinxScopeName=="sh/index"
      @asString=@content; @availableAsString = true;
    end
  end

  def initialize(data)
    @availableAsString = false;
    @dependsOn = [];
    @sphinxScopeName = data["path"].gsub(".rst","");
    #@sphinxScopeName = @sphinxScopeName.split('/').drop(1).join('/');
    @location = (data["path"]).split('/')[...-1];
    @content = data["content"];
    @matchAry = matchDataAry(@content);
    fillInFolderFiles();
    fillDependsOn();
    #call if @dependsOnIndexes.size() == 0
    pp "creating obj #{data["path"]}";
    initialConstructString();
    h={}; h.store("path", @sphinxScopeName); h.store("content", @asString);
    @@rstFiles.append(h) if @availableAsString
  end

end
