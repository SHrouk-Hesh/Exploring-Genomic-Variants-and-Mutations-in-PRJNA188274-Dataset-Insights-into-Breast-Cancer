sudo apt-get install samtools bcftools
for i in ./*.sorted.bam;do
samtools mpileup -uf GRCh38_chr22.fa $i | bcftools call -mv -O b -o $i.bcf;
done


