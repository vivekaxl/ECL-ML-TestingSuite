﻿IMPORT * FROM ML;
IMPORT * FROM $;
IMPORT PBblas;
Layout_Cell := PBblas.Types.Layout_Cell;
//Number of neurons in the last layer is number of output assigned to each sample
INTEGER4 hl := 3;//number of nodes in the hiddenlayer
INTEGER4 f := 20;//number of input features

//input data

value_record := RECORD
real	f1	;
real	f2	;
real	f3	;
real	f4	;
real	f5	;
real	f6	;
real	f7	;
real	f8	;
real	f9	;
real	f10	;
real	f11	;
real	f12	;
real	f13	;
real	f14	;
real	f15	;
real	f16	;
real	f17	;
real	f18	;
real	f19	;
real	f20	;
INTEGER Label  ;
END;

input_data_tmp := DATASET('~online::maryam::mytest::cancer_20at_96sa_data', value_record, CSV);
ML.AppendID(input_data_tmp, id, input_data);
OUTPUT  (input_data, NAMED ('input_data'));

Sampledata_Format := RECORD
input_data.id;
input_data.f1	;
input_data.f2	;
input_data.f3	;
input_data.f4	;
input_data.f5	;
input_data.f6	;
input_data.f7	;
input_data.f8	;
input_data.f9	;
input_data.f10	;
input_data.f11	;
input_data.f12	;
input_data.f13	;
input_data.f14	;
input_data.f15	;
input_data.f16	;
input_data.f17	;
input_data.f18	;
input_data.f19	;
input_data.f20	;
END;

sample_table := TABLE(input_data,Sampledata_Format);
OUTPUT  (sample_table, NAMED ('sample_table'));

ML.ToField(sample_table, indepDataC);
OUTPUT  (indepDataC, NAMED ('indepDataC'));


//define the parameters for the back propagation algorithm
//ALPHA is learning rate
//LAMBDA is weight decay rate
REAL8 sparsityParam  := 0.1;
REAL8 BETA := 0.1;
REAL8 ALPHA := 0.1;
REAL8 LAMBDA :=0.1;
UNSIGNED2 MaxIter :=2;
UNSIGNED4 prows:=0;
UNSIGNED4 pcols:=0;
UNSIGNED4 Maxrows:=0;
UNSIGNED4 Maxcols:=0;
//initialize weight and bias values for the Back Propagation algorithm
IntW := DeepLearning.Sparse_Autoencoder_IntWeights(f,hl);
Intb := DeepLearning.Sparse_Autoencoder_IntBias(f,hl);
OUTPUT(IntW,ALL, named ('IntW'));
OUTPUT(IntB,ALL, named ('IntB'));
//trainer module
SA :=DeepLearning.Sparse_Autoencoder(prows, pcols, Maxrows,  Maxcols);

LearntModel := SA.LearnC(indepDataC,IntW, Intb,BETA, sparsityParam, LAMBDA, ALPHA, MaxIter);
OUTPUT(LearntModel, named ('LearnModel'));

MatrixModel := SA.Model (LearntModel);
OUTPUT(MatrixModel, named ('MatrixModel'));

Out := SA.SAOutput (indepDataC, LearntModel);
OUTPUT(Out, named ('Out'));
