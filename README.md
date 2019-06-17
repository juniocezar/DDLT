# Demand-Driven Less-Than Analysis

A less-than analysis is a technique used by compilers to build a
partial ordering between the integer variables in a program. Here we introduce an algorithm that builds less-than relations on demand for pointer analysis. It was implemented onto the LLVM compilation infrastructure. Depending on the client analysis, this implementation may lead to runtime savings of up to 68% on large benchmarks, when compared to the more traditional
approach based on the construction of the transitive closure.

For example, in the code below:

```C
1    struct S {
2      int acc;
3      int size;
4      int *vet;
5    };
6
7    int fun1 (struct S *stt, struct S *stt2) {
8    int i;
9
10   for(i = 0; i < stt->size; i++) {
11     stt->acc += (stt->vet)[i];
12   }
13
14   stt2->acc += (stt2->vet)[stt2->size - 1];
15
16   return stt2->acc + stt->acc;
17 }
```
We have that an alias analysis, supported by less-than information, can disambiguate pointers in the loop inside fun1. However, more traditional approaches (shipped by default in LLVM) cannot do it.

More details are available in the paper:
[Demand-Driven Less-than Analysis](https://dl.acm.org/citation.cfm?id=3125379)


## Structure
* The directory **baseline** contains the original implementation of less-than analysis for pointer disambiguation proposed by [Paisante et. al.](https://github.com/vmpaisante/sraa)

* The directory **demand-drive-lt** contains a demand-driven approach for handling the same problem.

* **requirements/vSSA** contains the implementation of an extended version of the traditional *Single Static Assignment*

* **requirements/RangeAnalysis** contains an implementation of Integer Range Analysis for LLVM.



## Installation & Usage

First, you need to download and compile LLVM 3.7.

```bash
git clone https://github.com/juniocezar/DDLT.git && cd DDLT
cd baseline && ./configure && make
cd ../demand-drive-lt && ./configure && make
```

These commands will generate two shared libraries. You need to copy them to the LLVM lib dir and run:

```bash
opt -load RangeAnalysis.so -load SRAA.so -disable-output -stats -time-passes -sraa $INPUTFILE
```


## License
GPL