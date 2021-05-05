import "salmon.wdl" as salmon_wdl

workflow run_multi_salmon {
    # input bams must be name sorted
    Array[Map[String,File]]  fastqs
    scatter(fastq in fastqs) {
        call salmon_wdl.salmon as run_salmon {
            input:
               fastq1 = fastq['fastq1'],
               fastq2 = fastq['fastq2'],
               prefix = fastq['prefix']
        }
    }
}
