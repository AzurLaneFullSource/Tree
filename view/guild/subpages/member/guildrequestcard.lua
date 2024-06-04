local var0 = class("GuildRequestCard")

function var0.Ctor(arg0, arg1)
	arg0.tf = tf(arg1)
	arg0.nameTF = arg0.tf:Find("frame/request_info/name"):GetComponent(typeof(Text))
	arg0.levelTF = arg0.tf:Find("frame/request_info/level"):GetComponent(typeof(Text))
	arg0.dateTF = arg0.tf:Find("frame/request_info/date"):GetComponent(typeof(Text))
	arg0.msg = arg0.tf:Find("frame/request_content/Text"):GetComponent(typeof(Text))
	arg0.iconTF = arg0.tf:Find("frame/shipicon/icon"):GetComponent(typeof(Image))
	arg0.starsTF = arg0.tf:Find("frame/shipicon/stars")
	arg0.circle = arg0.tf:Find("frame/shipicon/frame")
	arg0.starTF = arg0.tf:Find("frame/shipicon/stars/star")
	arg0.rejectBtn = arg0.tf:Find("frame/refuse_btn")
	arg0.accpetBtn = arg0.tf:Find("frame/accpet_btn")
end

function var0.Update(arg0, arg1)
	arg0:Clear()

	arg0.requestVO = arg1
	arg0.nameTF.text = arg1.player.name
	arg0.levelTF.text = "Lv." .. arg1.player.level

	local var0 = getOfflineTimeStamp(arg1.timestamp)

	arg0.dateTF.text = var0
	arg0.msg.text = arg1.content

	local var1 = arg1.player
	local var2 = AttireFrame.attireFrameRes(var1, var1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var1.propose)

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

	local var3 = pg.ship_data_statistics[arg1.player.icon]

	if var3 then
		local var4 = arg1.player:getPainting()

		LoadSpriteAsync("qicon/" .. var4, function(arg0)
			arg0.iconTF.sprite = arg0
		end)

		local var5 = arg0.starsTF.childCount

		for iter0 = var5, var3.star - 1 do
			cloneTplTo(arg0.starTF, arg0.starsTF)
		end

		for iter1 = 1, var5 do
			local var6 = arg0.starsTF:GetChild(iter1 - 1)

			setActive(var6, iter1 <= var3.star)
		end
	end
end

function var0.Clear(arg0)
	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0)
		local var1 = var0.gameObject.name

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var1, var1, var0.gameObject)
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
