local var0 = class("DockyardFriend")

var0.DetailType0 = 0
var0.DetailType1 = 1
var0.DetailType2 = 2

local var1 = 0.5

function var0.Ctor(arg0, arg1)
	arg0.go = arg1
	arg0.tf = arg1.transform
	arg0.nameTF = arg0.tf:Find("content/request_info/name"):GetComponent(typeof(Text))
	arg0.levelTF = arg0.tf:Find("content/request_info/lv_bg/lv/Text"):GetComponent(typeof(Text))
	arg0.iconTF = arg0.tf:Find("content/icon_contaon/icon"):GetComponent(typeof(Image))
	arg0.starsTF = arg0.tf:Find("content/icon_contaon/stars")
	arg0.starTF = arg0.tf:Find("content/icon_contaon/stars/star")
	arg0.date = arg0.tf:Find("content/date"):GetComponent(typeof(Text))
	arg0.manifestoTF = arg0.tf:Find("content/request_content/bg/Text"):GetComponent(typeof(Text))
	arg0.powerTF = arg0.tf:Find("content/item/value")
	arg0.propose = arg0.tf:Find("content/icon_contaon/propose")
	arg0.content = arg0.tf:Find("content")
	arg0.detail = arg0.tf:Find("detail")
	arg0.detailLayoutTr = findTF(arg0.detail, "layout")
	arg0.quit = arg0.tf:Find("quit_button")
	arg0.selectedGo = findTF(arg0.tf, "selected").gameObject

	arg0.selectedGo:SetActive(false)
end

function var0.update(arg0, arg1, arg2)
	if arg0.shipVO ~= arg1 then
		arg0.shipVO = arg1

		local var0 = tobool(arg1)

		if var0 then
			arg0.friendVO = arg2[arg1.playerId]

			arg0:flush()
			arg0:flushDetail()
		end

		setActive(arg0.content, var0)
		setActive(arg0.quit, not var0)
	end
end

function var0.updateSelected(arg0, arg1)
	arg0.selected = arg1

	arg0.selectedGo:SetActive(arg0.selected)

	if arg0.selected then
		if not arg0.selectedTwId then
			arg0.selectedTwId = LeanTween.alpha(arg0.selectedGo.transform, 1, var1):setFrom(0):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId
		end
	elseif arg0.selectedTwId then
		LeanTween.cancel(arg0.selectedTwId)

		arg0.selectedTwId = nil
	end
end

function var0.flush(arg0)
	if arg0.shipVO then
		local var0 = pg.ship_data_statistics[arg0.shipVO.configId]

		LoadSpriteAsync("qicon/" .. arg0.shipVO:getPainting(), function(arg0)
			arg0.iconTF.sprite = arg0
		end)
		setActive(arg0.propose, arg0.shipVO:ShowPropose())

		local var1 = arg0.starsTF.childCount

		for iter0 = var1, var0.star - 1 do
			cloneTplTo(arg0.starTF, arg0.starsTF)
		end

		for iter1 = 1, var1 do
			local var2 = arg0.starsTF:GetChild(iter1 - 1)

			setActive(var2, iter1 <= var0.star)
		end
	end

	if arg0.friendVO then
		arg0.nameTF.text = arg0.friendVO.name
		arg0.levelTF.text = arg0.friendVO.level
		arg0.manifestoTF.text = arg0.friendVO.manifesto or ""

		if arg0.friendVO.online == Friend.ONLINE then
			arg0.date.text = i18n("word_online")
		else
			arg0.date.text = getOfflineTimeStamp(arg0.friendVO.preOnLineTime)
		end
	end
end

function var0.updateDetail(arg0, arg1)
	arg0.detailType = arg1

	arg0:flushDetail()
end

function var0.flushDetail(arg0)
	local var0 = arg0.shipVO
	local var1 = tobool(var0)

	if var1 and arg0.detailType > var0.DetailType0 then
		local var2 = var0:getShipProperties()
		local var3 = {
			"name",
			AttributeType.Durability,
			AttributeType.Cannon,
			AttributeType.Torpedo,
			AttributeType.Air,
			AttributeType.AntiAircraft,
			AttributeType.ArmorType,
			AttributeType.Reload,
			AttributeType.Dodge
		}
		local var4 = var0:getShipCombatPower()

		for iter0 = 1, 6 do
			local var5 = arg0.detailLayoutTr:GetChild(iter0 - 1)
			local var6 = var5:GetChild(0):GetComponent("Text")
			local var7 = var5:GetChild(1):GetComponent("Text")

			if arg0.detailType == var0.DetailType1 then
				if iter0 == 1 then
					var6.alignment = TextAnchor.MiddleCenter
					var6.text = arg0.shipVO:getName()
					var7.text = ""
				else
					local var8 = var3[iter0]

					var6.text = AttributeType.Type2Name(var8)
					var7.text = tostring(math.floor(var2[var8]))
				end
			elseif arg0.detailType == var0.DetailType2 then
				if iter0 == 6 then
					var6.text = "<color=#A9F548FF>" .. i18n("word_synthesize_power") .. "</color>"
					var7.text = tostring(var4)
				elseif iter0 == 5 then
					var6.text = "<color=#A9F548FF>" .. i18n("word_level") .. "</color>"
					var7.text = "Lv." .. arg0.shipVO.level
				elseif iter0 == 1 then
					var6.alignment = TextAnchor.MiddleCenter
					var6.text = var0:getShipArmorName()
					var7.text = ""
				elseif iter0 == 4 then
					var6.text = AttributeType.Type2Name(AttributeType.Expend)

					local var9 = var0:getBattleTotalExpend()

					var7.text = tostring(math.floor(var9))
				else
					local var10 = var3[iter0 + 6]

					var6.text = AttributeType.Type2Name(var10)
					var7.text = tostring(math.floor(var2[var10]))
				end
			end
		end
	end

	setActive(arg0.detail, var1 and arg0.detailType > var0.DetailType0)
end

function var0.clear(arg0)
	if arg0.selectedTwId then
		LeanTween.cancel(arg0.selectedTwId)

		arg0.selectedTwId = nil
	end
end

return var0
