local var0 = class("IdolMedalCollectionView3", import(".IdolMedalCollectionView2"))

function var0.GetContainerPositions(arg0)
	return {
		0,
		100
	}
end

function var0.GetActivityID(arg0)
	return ActivityConst.MUSIC_FESTIVAL_MEDALCOLLECTION_3
end

function var0.getUIName(arg0)
	return "IdolMedalCollectionUI3"
end

function var0.didEnter(arg0)
	local var0 = math.random()

	setActive(arg0:findTF("1", arg0.bg), var0 >= 0.5)
	setActive(arg0:findTF("2", arg0.bg), var0 < 0.5)
	var0.super.didEnter(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idol3rd_collection.tip
		})
	end, SFX_PANEL)
end

function var0.IsShowMainTip(arg0)
	return Activity.IsActivityReady(arg0)
end

return var0
