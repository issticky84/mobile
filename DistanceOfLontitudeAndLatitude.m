function d = DistanceOfLontitudeAndLatitude(lat1,lat2,lon1,lon2)
    R = 6371; % km
    theta1 = degtorad(lat1);
    theta2 = degtorad(lat2);
    delta_theta = degtorad(lat2-lat1);
    delta_lumda = degtorad(lon2-lon1);
    a = sin(delta_theta/2) * sin(delta_theta/2) + cos(theta1) * cos(theta2) * sin(delta_lumda/2) * sin(delta_lumda/2);
    c = 2 * atan2(sqrt(a),sqrt(1-a));
    d = R * c;
% var R = 6371; // km
% var £p1 = lat1.toRadians();
% var £p2 = lat2.toRadians();
% var £G£p = (lat2-lat1).toRadians();
% var £G£f = (lon2-lon1).toRadians();
% 
% var a = Math.sin(£G£p/2) * Math.sin(£G£p/2) +
%         Math.cos(£p1) * Math.cos(£p2) *
%         Math.sin(£G£f/2) * Math.sin(£G£f/2);
% var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
% 
% var d = R * c;   
end