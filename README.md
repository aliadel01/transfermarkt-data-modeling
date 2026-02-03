# TransferMarket Data Modeling Project

A comprehensive data engineering project that transforms TransferMarket dataset into a star schema and evaluates different storage formats (CSV, Avro, Parquet) on HDFS.

## 📋 Project Overview

This project models football transfer market data into a star schema and implements it on HDFS in multiple file formats. It includes performance benchmarking across different formats and compression algorithms.

## Data Modeling
![](modeling/model.jpeg)

## Project Reference
- [Project Task & Requirements](https://github.com/ahmedshaaban1999/Data_Engineering_Mentorship/tree/main/level_1/Data_Modeling/projects/transferMarket)
- [TransferMarket Dataset](https://www.kaggle.com/datasets/davidcariboo/player-scores) from Kaggle - Contains player transfers, valuations, and related football market data.

## 🎯 Objectives
1. Design and implement a star schema for TransferMarket data
2. Load data into HDFS in CSV, Avro, and Parquet formats
3. Benchmark storage size, write speed, and read speed
4. Evaluate multiple compression algorithms and levels

## 🛠️ Technologies

- **Storage**: HDFS (Hadoop Distributed File System)
- **Formats**: CSV, Avro, Parquet
- **Compression**: Snappy, Gzip, LZO (and others)
- **Processing**: Apache Spark / Python



## 📦 Deliverables

1. **Star Schema Design** - Dimensional model with fact and dimension tables
2. **Performance Comparison Report** - Detailed analysis of:
   - File sizes across formats
   - Write performance metrics
   - Read performance metrics
   - Compression algorithm comparison

## 📁 Repository Structure

```
├── schema/              # Star schema design and documentation
├── data/                # Raw and processed data files
├── scripts/             # Data loading and transformation scripts
├── benchmarks/          # Performance testing results
└── docs/                # Project documentation and reports
```

## 🚀 Getting Started

_Instructions coming soon_

## 📝 License

This project is for educational purposes.
```