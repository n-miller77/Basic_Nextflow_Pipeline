#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { FASTP          } from './modules/nf-core/fastp/main'
include { SPADES         } from './modules/nf-core/spades/main'
include { BOWTIE2_BUILD  } from './modules/nf-core/bowtie2/build/main'
include { BOWTIE2_ALIGN  } from './modules/nf-core/bowtie2/align/main'

log.info """
    ================================================
    Metagenome Overall Workflow
    ================================================
    reads_r1   : ${params.reads_r1}
    reads_r2   : ${params.reads_r2}
    mag_fasta  : ${params.mag_fasta}
    outdir     : ${params.outdir}
    threads    : ${params.threads}
    ================================================
    """.stripIndent()

workflow {

    // ── input channels ───────────────────────────
    ch_reads = Channel
        .fromPath([params.reads_r1, params.reads_r2])
        .collect()
        .map { r1, r2 -> [ [id: 'metagenome', single_end: false], [r1, r2] ] }

    ch_mag = Channel
        .fromPath(params.mag_fasta, checkIfExists: true)
        .map { fasta -> [ [id: fasta.baseName], fasta, [] ] }

    // ── Module 1: fastp for trimming (sequential) ─────────────
    ch_reads_with_adapter = ch_reads.map { meta, reads -> [ meta, reads, [] ] }
    FASTP(ch_reads_with_adapter, false, false, false)

    // ── Modules 2 and 3: run IN PARALLEL ─────────

    // 2: spades metagenomic assembly
    // takes trimmed reads from fastp
    SPADES(
        FASTP.out.reads.map { meta, reads ->
            [ meta, reads, [], [] ]
        },
        [],
        []
    )

    // 3: bowtie2 - map trimmed reads to MAG
    // also takes trimmed reads from fastp
    // runs at same time as spades
    BOWTIE2_BUILD(ch_mag)

    BOWTIE2_ALIGN(
        FASTP.out.reads,
        BOWTIE2_BUILD.out.index,
        [ [], [], [] ],
        false,
        true
    )
}
