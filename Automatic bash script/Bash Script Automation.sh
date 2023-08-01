echo"make sure that you have installed all the tools, I have already installed them, so this code may not be run with you"


#downloading the data 
echo "enter acc number:"
read acc_num

esearch -db sra -query $acc_num |\ efetch -format runinfo | cut -d "," -f 1 | grep SRR | xargs -d '\n'fastq-dump -X 10000 --skip-technical --read-filter pass --dumpbase --gzip

########################################



#applying quality visualization on raw data

echo "-----------------------------------------------------------------------------"
echo "quality of the data"

for f in ./*.fq.gz;do fastqc -t 1 -f fastq -noextract "$f";done

#############################################

#trimming and shuffling 

echo "if you want to apply trimming only press 0/ trimming and shuffling press 1 / shuflling only perss 2/ if nothing press any key"

read key

if [ $key -eq 0 ]; then
    
for file in ./*.fastq.gz; do
    filename=$(basename "$file")
    output="trimmed/${filename%.*}_trimmed.fastq"
    java -jar trimmomatic-0.39.jar SE -threads 1 "$file" "$output" LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

elif [$key -eq 1]; then

for i in ./*.fastq.gz; do seqkit shuffle $i > $i.shuffled;done

for file in ./*.shuffled; do
 	filename=$(basename "$file")
 	output="trimmed/${filename%.*}_trimmed.fastq"
 	java -jar trimmomatic-0.39.jar SE -threads 1 "$file" "$output" LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done



elif [$key -eq 2]; then

for i in ./*.fastq.gz; do seqkit shuffle $i > $i.shuffled.fa



else
    echo "ahsan wafrt bardo"
fi


#################################################################


# alignment
#downloading reference
echo "enter the acc number of reference"
read ref

esearch -db nucleotide -query $ref | efetch -format fasta > ref.fa

#indexing reference
bwa index -a ref.fa

if [ $key -eq 0 or $key -eq 1 ]; then
for i in ./*.trimmed; do
bwa mem -t 4 GRCh38_chr22.fa $i > $i.sam;

elif [$key -eq 2]; then
for i in ./*.fa; do
bwa mem -t 4 GRCh38_chr22.fa $i > $i.sam;

else 
for i in ./*.fastq.gz
bwa mem -t 4 GRCh38_chr22.fa $i > $i.sam;
done

for i in./*.sam; do
samtools view -bS $i > $i.bam | samtools index output.bam;done


#######bcf 

# first sort bam files

for i in ./*.bam;do samtools sort $i -o $i;done

# indexing the reference 
samtools faidx samtools faidx GRCh38_chr22.fa

#variant calling
for i in ./*.bam; do bcftools mpileup -Ou -f GRCh38_chr22.fa $i | bcftools call -vmO z -o $i.vcf.gz;done

#########################


echo "download IGV to view the bam files"

