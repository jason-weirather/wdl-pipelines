import "fastqc.wdl" as fastqc_wdl
import "salmon.wdl" as salmon_wdl

workflow run_multi_rnaseq {
    Array[Map[String,File]]  fastqs

    # Recommended option
    File? geneMap

    # Required options
    Int? memory_fastqc = 16
    Int? memory_salmon = 32
    Int? disk_space = 100
    Int? num_cpu_fastqc = 4
    Int? num_cpu_salmon = 16
    Int? num_preempt = 0
    Int? boot_disk_gb = 40
    
    # Options for run
    Int? seqBias = 0
    Int? gcBias = 0

    String? docker_fastqc = "biocontainers/fastqc:v0.11.9_cv8"
    String? docker_salmon = "combinelab/salmon:1.4.0"

    scatter(fastq in fastqs) {
        call fastqc_wdl.fastqc as run_fastqc1 {
            input:
               fastq = fastq['fastq1'],
               prefix = fastq['prefix'],
               type = 'left',

               docker = docker_fastqc,
               memory = memory_fastqc,
               disk_space = disk_space,
               num_cpu = num_cpu_fastqc,
               num_preempt = num_preempt,
               boot_disk_gb = boot_disk_gb
        }
        call fastqc_wdl.fastqc as run_fastqc2 {
            input:
               fastq = fastq['fastq2'],
               prefix = fastq['prefix'],
               type = 'right',

               docker = docker_fastqc,
               memory = memory_fastqc,
               disk_space = disk_space,
               num_cpu = num_cpu_fastqc,
               num_preempt = num_preempt,
               boot_disk_gb = boot_disk_gb
        }
        call salmon_wdl.salmon as run_salmon {
            input:
               fastq1 = fastq['fastq1'],
               fastq2 = fastq['fastq2'],
               prefix = fastq['prefix'],
               geneMap = geneMap,
               seqBias = seqBias,
               gcBias = gcBias,

               docker = docker_salmon,
               memory = memory_salmon,
               disk_space = disk_space,
               num_cpu = num_cpu_salmon,
               num_preempt = num_preempt,
               boot_disk_gb = boot_disk_gb
        }
    }
}
