# SNP_analysis
Scripts containing information of SNP analysis and Vizualsation.




1. MUMMER

- For a single comparison A-B

  - create comparison delta file

        ~/software/Mummer4/mummer-4.0.0beta2/nucmer --prefix=N16961_Pacbio-Ncbi Vibrio_cholerae_N16961_BloLabStrain_PacBio.fasta Vibrio_cholerae_N16961_NCBI_Complete.fna

  - delete conflicting repears copies

        ~/software/Mummer4/mummer-4.0.0beta2/delta-filter -r -q N16961_Pacbio-Ncbi.delta > N16961_Pacbio-Ncbi.filter

  - Make comparison report

        ~/software/Mummer4/mummer-4.0.0beta2/dnadiff -d N16961_Pacbio-Ncbi.filter


- in loop among multiple files

  - Change names of contigs to get proper contig names 
      (i.e. BLABLA 312513VW53sc?/)/(*ç  ) 

        mkdir SNP_Mummer
        for i in $(ls Vibrio*.fna); do cat $i | sed 's/_length/\tlength/' > SNP_Mummer/$i; done

  - Create Delta file

        for pri in $(ls *.fna); do echo ¯\_\(\ツ\)_/¯$(echo $pri | cut -d '_' -f3); for sec in $(ls *.fna);  do echo @@@@@@$(echo $sec | cut -d '_' -f3)@@@@@@ ; ~/software/Mummer4/mummer-4.0.0beta2/nucmer --prefix=$(echo $pri | cut -d '_' -f3)@$(echo $sec | cut -d '_' -f3) $pri $sec; done; done

   - delete conflicting repeats

          for i in $(ls *.delta); do echo ¯\_\(\ツ\)_/¯$(echo $i | cut -d '_' -f3)¯\_\(\ツ\)_/¯; ~/software/Mummer4/mummer-4.0.0beta2/delta-filter -r -q $i > $(echo $i| cut -d'.' -f1).filter; done 

   - Make comparison

          for i in $(ls *.filter); do echo ¯\_\(\ツ\)_/¯$(echo $i | cut -d '_' -f3)¯\_\(\ツ\)_/¯; ~/software/Mummer4/mummer-4.0.0beta2/dnadiff -d $i; mv out.report $(echo $i | cut -d'.' -f1).report;mv out.rdiff $(echo $i | cut -d'.' -f1).rdiff; mv out.qdiff $(echo $i | cut -d'.' -f1).qdiff; mv out.unref $(echo $i | cut -d'.' -f1).unref; mv out.unqry $(echo $i | cut -d'.' -f1).unqry;  mv out.1delta $(echo $i | cut -d'.' -f1).1delta;  mv out.mdelta $(echo $i | cut -d'.' -f1).mdelta; mv out.1coords $(echo $i | cut -d'.' -f1).1coords; mv out.mcoords $(echo $i | cut -d'.' -f1).mcoords; mv out.snps $(echo $i | cut -d'.' -f1).snps; done 


2. MAUVE

- MAKE MULTIPLE ALIGNEMENT

- CREATE SNP FILE BY CLICKING ON EXPORT. PUT SAME NAME WITH EXTENSION .SNP

- IN R USE SCRIPT SNP_MAUVE_plot.R  

				- > Create matrix of SNP between STRAINS
				- > Create Network of SNP 
				- > Create hierarchical clustering dendogram 



