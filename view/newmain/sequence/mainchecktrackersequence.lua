local var0_0 = class("MainCheckTrackerSequence")
local var1_0

function var0_0.Execute(arg0_1, arg1_1)
	if var1_0 ~= pg.proxyRegister.loginMark then
		var1_0 = pg.proxyRegister.loginMark

		PlayerConst.CheckMedalAllCollectionTrack()
		Apartment.CheckAllCollectionTrack()
		EducateConst.CheckAllCollectionTrack()
	end

	arg1_1()
end

return var0_0
