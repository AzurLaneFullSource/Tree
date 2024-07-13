local var0_0 = class("FriendCard")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.go = arg1_1
	arg0_1.tf = tf(arg1_1)
	arg0_1.nameTF = arg0_1.tf:Find("frame/request_info/name_bg/Text"):GetComponent(typeof(Text))
	arg0_1.iconTF = arg0_1.tf:Find("icon/icon_bg/icon"):GetComponent(typeof(Image))
	arg0_1.circle = arg0_1.tf:Find("icon/icon_bg/frame")
	arg0_1.starList = UIItemList.New(arg0_1.tf:Find("icon/icon_bg/stars"), arg0_1.tf:Find("icon/icon_bg/stars/star"))
	arg0_1.manifestoTF = arg0_1.tf:Find("frame/request_content/Text"):GetComponent(typeof(Text))
	arg0_1.resumeBtn = arg0_1.tf:Find("resume_btn")
end

function var0_0.update(arg0_2, arg1_2)
	arg0_2:clear()

	arg0_2.friendVO = arg1_2
	arg0_2.nameTF.text = arg1_2.name

	local var0_2 = pg.ship_data_statistics[arg1_2.icon]
	local var1_2 = Ship.New({
		configId = arg1_2.icon
	})

	LoadSpriteAsync("qicon/" .. var1_2:getPrefab(), function(arg0_3)
		arg0_2.iconTF.sprite = arg0_3
	end)

	local var2_2 = AttireFrame.attireFrameRes(arg1_2, arg1_2.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1_2.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_2, var2_2, true, function(arg0_4)
		if IsNil(arg0_2.tf) then
			return
		end

		if arg0_2.circle then
			arg0_4.name = var2_2
			findTF(arg0_4.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_4, arg0_2.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_2, var2_2, arg0_4)
		end
	end)

	local var3_2 = var1_2:getStar()

	arg0_2.starList:align(var3_2)
end

function var0_0.clear(arg0_5)
	if arg0_5.circle.childCount > 0 then
		local var0_5 = arg0_5.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_5.name, var0_5.name, var0_5)
	end
end

function var0_0.dispose(arg0_6)
	pg.DelegateInfo.Dispose(arg0_6)
	arg0_6:clear()
end

return var0_0
