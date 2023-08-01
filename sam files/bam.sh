for i in ./*.sam;do
samtools view -bS $i > $i.bam; done
