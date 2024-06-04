local var0 = class("FriendCard")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.go = arg1
	arg0.tf = tf(arg1)
	arg0.nameTF = arg0.tf:Find("frame/request_info/name_bg/Text"):GetComponent(typeof(Text))
	arg0.iconTF = arg0.tf:Find("icon/icon_bg/icon"):GetComponent(typeof(Image))
	arg0.circle = arg0.tf:Find("icon/icon_bg/frame")
	arg0.starList = UIItemList.New(arg0.tf:Find("icon/icon_bg/stars"), arg0.tf:Find("icon/icon_bg/stars/star"))
	arg0.manifestoTF = arg0.tf:Find("frame/request_content/Text"):GetComponent(typeof(Text))
	arg0.resumeBtn = arg0.tf:Find("resume_btn")
end

function var0.update(arg0, arg1)
	arg0:clear()

	arg0.friendVO = arg1
	arg0.nameTF.text = arg1.name

	local var0 = pg.ship_data_statistics[arg1.icon]
	local var1 = Ship.New({
		configId = arg1.icon
	})

	LoadSpriteAsync("qicon/" .. var1:getPrefab(), function(arg0)
		arg0.iconTF.sprite = arg0
	end)

	local var2 = AttireFrame.attireFrameRes(arg1, arg1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2, var2, true, function(arg0)
		if IsNil(arg0.tf) then
			return
		end

		if arg0.circle then
			arg0.name = var2
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2, var2, arg0)
		end
	end)

	local var3 = var1:getStar()

	arg0.starList:align(var3)
end

function var0.clear(arg0)
	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
	end
end

function var0.dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:clear()
end

return var0
