local var0 = class("MainRightPanel", import("...base.MainConcealablePanel"))

function var0.GetBtns(arg0)
	return {
		MainMemoryBtn.New(findTF(arg0._tf, "memoryButton"), arg0.event),
		MainCollectionBtn.New(findTF(arg0._tf, "collectionButton"), arg0.event),
		MainRankBtn.New(findTF(arg0._tf, "rankButton"), arg0.event),
		MainFriendBtn.New(findTF(arg0._tf, "friendButton"), arg0.event),
		MainMailBtn.New(findTF(arg0._tf, "mailButton"), arg0.event),
		MainNoticeBtn.New(findTF(arg0._tf, "noticeButton"), arg0.event),
		MainSettingsBtn.New(findTF(arg0._tf, "settingButton"), arg0.event),
		MainFormationBtn.New(findTF(arg0._tf, "formationButton"), arg0.event),
		MainBattleBtn.New(findTF(arg0._tf, "combatBtn"), arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(1, 0)
end

return var0
