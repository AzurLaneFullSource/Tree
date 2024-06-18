local var0_0 = class("IdolMedalCollectionView3", import(".IdolMedalCollectionView2"))

function var0_0.GetContainerPositions(arg0_1)
	return {
		0,
		100
	}
end

function var0_0.GetActivityID(arg0_2)
	return ActivityConst.MUSIC_FESTIVAL_MEDALCOLLECTION_3
end

function var0_0.getUIName(arg0_3)
	return "IdolMedalCollectionUI3"
end

function var0_0.didEnter(arg0_4)
	local var0_4 = math.random()

	setActive(arg0_4:findTF("1", arg0_4.bg), var0_4 >= 0.5)
	setActive(arg0_4:findTF("2", arg0_4.bg), var0_4 < 0.5)
	var0_0.super.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idol3rd_collection.tip
		})
	end, SFX_PANEL)
end

function var0_0.IsShowMainTip(arg0_6)
	return Activity.IsActivityReady(arg0_6)
end

return var0_0
