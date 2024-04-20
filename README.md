I was reading "linux kernel programming" book and followed the authors advice to be empirical.
And tried the less resource consuming build(imo) > let's build the kernel docs.
My intention was to read them on 6" ebook reader.
But 'make pdfdocs' fails, that's a fact, and a very disappointing one.
Of course there are htmldocs avail. online e.g https://kernel.org/doc/html/ 
one can even pick a version of interest, but there are any pdf's.
So i started playing around with capturing the documentation structure in the index.rst files.

only <.. toctree> directive is reproduced
Kernel version used is 5.4, just like in first edition of the book

Here is how to setup:
- clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
- remote add stable https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux
- fetch stable
- git checkout -b 'branchName' stable/linux-5.4.y

- apply patch
- run genrate rb

