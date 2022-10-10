print "Enter name of file with forward reads: \n";
my $forvard_file = <STDIN>; 
chomp $forvard_file;
#print "\n forvard_file = $forvard_file\n";

print "Enter name of file with reverse reads: \n";
my $reverse_file = <STDIN>; 
chomp $reverse_file;
#print "\n reverse_file = $reverse_file";

open INFILE, "< $forvard_file";
open OUTFILE, "> forvard_mod.fastq";
open INFILE2, "< $reverse_file";
open OUTFILE2, "> reverse_mod.fastq";
@massiv1=<INFILE>;
@massiv2=<INFILE2>;
$ns=0;
while($massiv1[$ns]) #определяем количество строк в INFILE
{
$ns++
}
$ns1max=$ns;

$ns2=0;
while($massiv2[$ns2]) #определяем количество строк в INFILE2
{
$ns2++
}
$ns2max=$ns2;
print "в файле forward.fq $ns1max строк, в файле reverse.fastq - $ns2max";


$ns=0;
while($massiv1[$ns]) 
{
$k=0;
while($k<10)#поиск идентификаторов чтений в файле forward начале интервала (около $ns). $nsmin - номер строки в которой есть идентификаторы 
{
#print "$k\n";
$b=index($massiv1[$ns+$k], "@");
$b2=index($massiv1[$ns+$k+2], "+");
$b3=index($massiv1[$ns+$k+3], "N");
#print 
if(($b==0)&&($b2==0)&&($b3<0))
{
	$massiv1[$ns+$k]=~/1:(\d+):(\d+):(\d+)/;
$id1_1=$1;
$id1_2=$2;
$id1_3=$3;
$id1_1=$id1_1+1;
$id1_2=$id1_2+1;
$id1_3=$id1_3+1;
$nsmin=$ns+$k; #возможно, будет лишняя переменная
$k=100;
}

$k++;	
}

#print " ns=$ns, k=$k,  nsmin=$nsmin, id1_1=$id1_1, id1_2=$id1_2, id1_3=$id1_3\n";




$ns2=0;
while($massiv2[$ns2]) #поиск идентификаторов чтений в файле reverse в начале интервала. $nsmin2 - номер строки, в которой есть идентификаторы, аналогичные тем, что есть в строке $nsmin в файле forvard
{
$b=index($massiv2[$ns2], "@");
$b2=index($massiv2[$ns2+2], "+");
$b3=index($massiv2[$ns2+3], "N");
#print 
if(($b==0)&&($b2==0)&&($b3<0))
{
$massiv2[$ns2]=~/1:(\d+):(\d+):(\d+)/;
$id3_1=$1;
$id3_2=$2;
$id3_3=$3;
$id3_1=$id3_1+1;
$id3_2=$id3_2+1;
$id3_3=$id3_3+1;

#$k2=$100; #возможно, будет лишняя переменная
if(($id1_1==$id3_1)&&($id1_2==$id3_2)&&($id1_3==$id3_3))
{
#print "nsmin=$nsmin;ns2=$ns2;id1_1=$id1_1;id1_2=$id1_2;id1_3=$id1_3;id3_1=$id3_1;id3_2=$id3_2;id3_3=$id3_3;\n$massiv1[$nsmin];$massiv2[$ns2] ";	
$nsmin2=$ns2;
$ns2=$ns2+$ns1max;
}
}
$ns2++
}

print "nsmin=$nsmin;nsmin2=$nsmin2;\n";


	
	
$nsprim=$ns+10000;
while(($nsprim-$ns)<10010) #поиск идентификаторов чтений в конце интервала (около $ns+1000). $nsmax - номер строки с идентификатором
{
$b=index($massiv1[$nsprim], "@");
$b2=index($massiv1[$nsprim+2], "+");
$b3=index($massiv1[$nsprim+3], "N");

if(($b==0)&&($b2==0)&&($b3<0))
{
	$massiv1[$nsprim]=~/1:(\d+):(\d+):(\d+)/;
$id2_1=$1;
$id2_2=$2;
$id2_3=$3;
$nsmax=$nsprim; #возможно, будет лишняя переменная
$nsprim=$nsprim+100;
}
	#print "$nsprim\n$massiv1[$nsprim]";
	$nsprim++;
}
#print "ns=$ns, nsprim=$nsprim,  nsmax=$nsmax, id2_1=$id2_1, id2_2=$id2_2, id2_3=$id2_3\n";




$ns3=0;
while($massiv2[$ns3]) #поиск идентификаторов чтений в файле reverse в конце интервала. $nsmax2 - номер строки, в которой есть идентификаторы, аналогичные тем, что есть в строке $nsmin в файле forvard
{
$b=index($massiv2[$ns3], "@");
$b2=index($massiv2[$ns3+2], "+");
$b3=index($massiv2[$ns3+3], "N");
#print 
if(($b==0)&&($b2==0)&&($b3<0))
{
$massiv2[$ns3]=~/1:(\d+):(\d+):(\d+)/;
$id4_1=$1;
$id4_2=$2;
$id4_3=$3;
#print "id4_1=$id4_1;id4_2=$id4_2;id4_3=$id4_3";


#$k2=$100; #возможно, будет лишняя переменная
if(($id2_1==$id4_1)&&($id2_2==$id4_2)&&($id2_3==$id4_3))
{
#print "nsmax=$nsmax;ns3=$ns3;id1_1=$id1_1;id1_2=$id1_2;id1_3=$id1_3;id3_1=$id3_1;id3_2=$id3_2;id3_3=$id3_3;\n$massiv1[$nsmin];$massiv2[$ns2] ";	
$nsmax2=$ns3;
$ns3=$ns3+$ns1max;
}
}
$ns3++
}

print "nsmax=$nsmax;nsmax2=$nsmax2;\n";




$ns4=$nsmin; #начало fq_to_fastq.pl
#print "@massiv1";
while($ns4<=$nsmax) 
{
#print "($massiv1[$ns4]";
$b=index($massiv1[$ns4], "@");
$b2=index($massiv1[$ns4+2], "+");
$b3=index($massiv1[$ns4+3], "N");
#print "$massiv1[$ns]$b;$b2;$b3\n";
if(($b==0)&&($b2==0)&&($b3<0))
{
	#print "ns4=$ns4\n$massiv1[$ns4]";
$massiv1[$ns4]=~/1:(\d+):(\d+):(\d+)/;
$id5_1=$1;
$id5_2=$2;
$id5_3=$3;
#print "ns4=$ns4;id5_1=$id5_1;id5_2=$id5_2;id5_3=$id5_3\n";
$ns5=$nsmin2;

while($ns5<=$nsmax2) 
{
$b4=index($massiv2[$ns5], "@");
$b5=index($massiv2[$ns5+2], "+");
$b6=index($massiv2[$ns5+3], "N");
#print "$massiv2[$ns5]$b4;$b5;$b6\n";
if(($b4==0)&&($b5==0)&&($b6<0))
{
	#print "$massiv2[$ns5]";
$massiv2[$ns5]=~/1:(\d+):(\d+):(\d+)/;
$id6_1=$1;
$id6_2=$2;
$id6_3=$3;
#print "$ns5;id6_1=$id6_1;id6_2=$id6_2;id6_3=$id6_3\n";
if(($id5_1==$id6_1)&&($id5_2==$id6_2)&&($id5_3==$id6_3))
{
#print "$massiv1[$ns4]";	
#print "$massiv2[$ns5]";
$massiv1[$ns4+1]=~/^.{2,3}(.+)/;
$sik=$1;
$massiv2[$ns5+1]=~/^.{2,3}(.+)/;
$sik2=$1;

#print "$massiv1[$ns4+1]$sik\n$massiv2[$ns5+1]$sik2\n";
	$b7=index($sik, "N");
	$b8=index($sik2, "N");
	if(($b7<0)&&($b8<0))
	{
print OUTFILE "$massiv1[$ns4]$sik\n$massiv1[$ns4+2]$massiv1[$ns4+3]";
print OUTFILE2 "$massiv2[$ns5]$sik2\n$massiv2[$ns5+2]$massiv2[$ns5+3]";

	}
$ns5=$ns5+10000;
#$ns4=$ns4+10000;
	
#print "$massiv1[$ns];$massiv2[$ns2]";

}
	
}

#print "$id1:$id2:$id3\n $massiv1[$ns]\n";
#print OUTFILE ">$ns\n";
#print OUTFILE "$massiv1[$ns-1]\n";
#print OUTFILE2 ">$ns\n";
#print OUTFILE2 "$massiv1[$ns-1]\n";
$ns5++;
}
}
$ns4++;
}
#конец fq_to_fastq.pl








$ns=$ns+10000;
}