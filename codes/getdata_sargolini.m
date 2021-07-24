function [trackpos,trackf,ts]=getdata_sargolini(fname,tID,cID,coord,trackw,radius_coord4)
% [trackpos,trackf,ts]=getdata_sargolini(fname,tID,cID,coord,trackw)
% extracts neural data with t1D and cID from fname and returns the
% locations, spike location and timestamps for locations. For output
% options, see coord below. To determine the width of the track to be
% considered, define trackw.

% INPUT:
% fname: file name
% tID: tetrode ID
% cID: cell ID
% coord: 0: untouched/ 1: cartesian with param (default)/ 2: cartesian autocenter
% / 3: linearized / 4: track extraction
% trackw: width of 'track' for the spikes to be considered; 0 if all spikes count
% radius_coord4: for coord = 4 only; center radius of the extracted track 

% OUTPUT:
% trackpos: scaled track position data
% trackf: scaled firing position data on track
% ts: timestamps for trackpos data

%% default
if nargin <=3
    coord = 1;
end
if nargin <=4
    trackw = 0; % all spikes considered
end

%% get data
load(fname);
ts = PosMtx(:,1);
trackpos = PosMtx(:,2:3); %;Pos(:,4)];  Both Tetrodes
fT = TTMtx(logical((TTMtx(:,2)==tID).*(TTMtx(:,3)==cID)),1);  % Timestamps of firing data with tetrode and cell ID
fT = fT(logical((fT>=ts(1)).*(fT<=ts(end))));   % discard spikes before and after the session
trackf = [interp1(ts,trackpos(:,1),fT,'nearest') interp1(ts,trackpos(:,2),fT,'nearest')]; % spike location set to be the animal location at the nearest time

run('Jacob_Sargolini_Data_param.m'); % contains all paramters + fitting
if coord > 0
    if coord == 1 || coord == 3 || coord == 4
        % parameters
        an = fname(1:4);
        switch an
            case {'1RS_','2BS_'}
                trackc = trackclist(1,:);
                sc = sclist(1);
            case {'MEC1','MEC2'}
                trackc = trackclist(2,:);
                sc = sclist(2);
            case {'MEC3','MEC4'}
                trackc = trackclist(3,:);
                sc = sclist(3);                    
        end
        trackf = trackf-trackc;
        trackpos = trackpos-trackc; 
    elseif coord == 2    % autocenter mode
        p = fitcirculartrack(trackpos);
        trackf = trackf-[p(1),p(2)];
        trackpos = trackpos-[p(1),p(2)]; 
        sc = rad/p(3);
    end
    % rescaling
    trackpos = trackpos*sc; % scale data to actual dimensions
    trackf = trackf*sc;
    % drop data outside trackw
    if trackw > 0
        if coord == 4
            rad = radius_coord4;
        end
        [~,rho] = cart2pol(trackpos(:,1),trackpos(:,2));
        trackpos = trackpos(abs(rho-rad)<trackw/2,:);
        [~,rho] = cart2pol(trackf(:,1),trackf(:,2));
        trackf = trackf(abs(rho-rad)<trackw/2,:);
    end
    % linearized
    if coord == 3
        trackpos = rad*mod(atan2(trackpos(:,2),trackpos(:,1)),2*pi);
        trackf = rad*mod(atan2(trackf(:,2),trackf(:,1)),2*pi);
    end
end

end