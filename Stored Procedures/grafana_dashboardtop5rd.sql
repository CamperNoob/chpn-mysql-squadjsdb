drop procedure if exists `grafana_dashboardtop5rd`;
create procedure `grafana_dashboardtop5rd`(lastVar int, lastTypeVar varchar(255), layerVar TEXT, serverVar TEXT, matchTimestamps TEXT)
begin 
	call sp_getstatsbytime(fn_getdatetimefromrange(lastVar,lastTypeVar,now()),now());
	call sp_getmatchidsbymap(layerVar);
	call sp_serveridsfromnamesjson(serverVar);
	call sp_getmatchidsbytimestamps(matchTimestamps);
	select playerName as Nickname, fn_calculateKD(sum(revives), sum(deaths)) as `Revive\Deaths`
	from getstatsbytime 
	where serverID in (select serverID from serveridsfromnamesjson) 
		and matchId in (select matchId from getmatchidsbymap) 
		and matchId in (select matchId from getmatchidsbytimestamps)
	group by playerName, steamId
	order by fn_calculateKD(sum(revives), sum(deaths)) desc
	limit 5;
	drop temporary table if exists getstatsbytime;
	drop temporary table if exists getmatchidsbymap;
	drop temporary table if exists serveridsfromnamesjson;
	drop temporary table if exists getmatchidsbytimestamps;
end