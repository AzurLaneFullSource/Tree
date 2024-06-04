local var0 = class("MainRightPanel4Mellow", import("...base.MainBasePanel"))

function var0.GetBtns(arg0)
	return {
		MainMemoryBtn.New(findTF(arg0._tf, "2/menor"), arg0.event),
		MainCollectionBtn.New(findTF(arg0._tf, "2/collection"), arg0.event),
		MainRankBtn4Mellow.New(findTF(arg0._tf, "2/rank"), arg0.event),
		MainFriendBtn.New(findTF(arg0._tf, "2/friend"), arg0.event),
		MainFormationBtn.New(findTF(arg0._tf, "1/formation"), arg0.event),
		MainBattleBtn.New(findTF(arg0._tf, "1/battle"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(1, 0)
end

return var0
