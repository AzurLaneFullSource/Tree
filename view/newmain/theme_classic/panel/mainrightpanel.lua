local var0_0 = class("MainRightPanel", import("...base.MainConcealablePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainMemoryBtn.New(findTF(arg0_1._tf, "memoryButton"), arg0_1.event),
		MainCollectionBtn.New(findTF(arg0_1._tf, "collectionButton"), arg0_1.event),
		MainRankBtn.New(findTF(arg0_1._tf, "rankButton"), arg0_1.event),
		MainFriendBtn.New(findTF(arg0_1._tf, "friendButton"), arg0_1.event),
		MainMailBtn.New(findTF(arg0_1._tf, "mailButton"), arg0_1.event),
		MainNoticeBtn.New(findTF(arg0_1._tf, "noticeButton"), arg0_1.event),
		MainSettingsBtn.New(findTF(arg0_1._tf, "settingButton"), arg0_1.event),
		MainFormationBtn.New(findTF(arg0_1._tf, "formationButton"), arg0_1.event),
		MainBattleBtn.New(findTF(arg0_1._tf, "combatBtn"), arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(1, 0)
end

return var0_0
