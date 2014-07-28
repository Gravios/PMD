
%% H32 Connector Mapping
H32CON = [15  6  5  4 16  3  2  1 32 31 30 17 29 28 27 18...
          13 12 11 10 14  9  8  7 26 25 24 19 23 22 21 20];

%% H32 A1X32 Linear Probe
H32LIN = [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24  9...
          25  8 26  7 27  6 28  5 29  4 30  3 31  2 32  1];

%% H32 Buzsaki32
H32BUZ = [ 1  8  2  7  3  6  4  5  9 16 10 15 11 14 12 13...
           17 24 18 23 19 22 20 21 25 32 26 31 27 30 28 29];


%% H64 Connector Mapping
H64CON = [31 22 21 20 32 19 18 17 48 47 46 33 45 44 43 34...
          23 24 25 30 26 27 28 29 36 37 38 39 35 40 41 42;...
           1  3  5  7  9 11 13 15 50 52 54 56 58 60 62 64...
           2  4  6  8 10 12 14 16 49 51 53 55 57 59 61 63];

%% H64 Buzsaki64
H32BUZ = [ 1  8  2  7  3  6  4  5  9 16 10 15 11 14 12 13...
          17 24 18 23 19 22 20 21 25 32 26 31 27 30 28 29;...
          33 40 34 39 35 38 36 37 41 48 42 47 43 46 44 45...
          49 56 50 55 51 54 52 53 57 64 58 63 59 62 60 61];



%% Contsruct Map Arrays
% always add maps in the order you plan to plug in your cables
%                    1st32    2nd32  ...

Connector_Map     = {H32CON, H32CON};
ElectrodeSite_Map = {H32BUZ, H32LIN};

%% Correct for Cummulative Channel Count
ChanCount = cellfun(@length,Connector_Map);
ChanCountShift = cumsum(ChanCount)';
ChanCountShift = mat2cell(circshift(ChanCountShift,1)',[1],ones([1,numel(ChanCountShift)]));
ChanCountShift{1} = 0;


Connector_Map     =  cell2mat(cellfun(@plus,Connector_Map    ,ChanCountShift,'uniformoutput',false)')';
ElectrodeSite_Map =  cell2mat(cellfun(@plus,ElectrodeSite_Map,ChanCountShift,'uniformoutput',false)')';


%% Sort out the Mapping
[~,conind] = sort(Connector_Map);
map = conind(ElectrodeSite_Map)-1;
map = [map,64,65];


%% Print Map to File
filename = '/gpfs01/sirota/data/bachdata/data/gravio/config/cheetah/Ed06_66_H32BUZ_H32LIN_C2NPCNEP.map';

fid = fopen(filename,'w');
i = [1:numel(map);map];
fprintf(fid,'%%acqEntName = CSC%i\n%%currentADChannel = %i\n-CreateCscAcqEnt %%acqEntName %%subSystemName\n	-SetChannelNumber 		%%acqEntName 	%%currentADChannel\n\n',i);
fclose(fid);
