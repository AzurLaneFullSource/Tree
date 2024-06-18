local var0_0 = class("MainRightPanel4Mellow", import("...base.MainBasePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainMemoryBtn.New(findTF(arg0_1._tf, "2/menor"), arg0_1.event),
		MainCollectionBtn.New(findTF(arg0_1._tf, "2/collection"), arg0_1.event),
		MainRankBtn4Mellow.New(findTF(arg0_1._tf, "2/rank"), arg0_1.event),
		MainFriendBtn.New(findTF(arg0_1._tf, "2/friend"), arg0_1.event),
		MainFormationBtn.New(findTF(arg0_1._tf, "1/formation"), arg0_1.event),
		MainBattleBtn.New(findTF(arg0_1._tf, "1/battle"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(1, 0)
end

return var0_0
