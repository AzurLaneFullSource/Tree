pg = pg or {}
pg.ChangeSkinMgr = singletonClass("ChangeSkinMgr")

local var0_0 = pg.ChangeSkinMgr
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.Init(arg0_1, arg1_1)
	arg0_1._go = nil
	arg0_1._spineContent = nil
	arg0_1._mvContent = nil
	arg0_1._live2dContent = nil
	arg0_1._spineUI = nil
	arg0_1._loadObject = nil
	arg0_1._loadObjectName = nil

	arg0_1:initUI(arg1_1)
end

function var0_0.initUI(arg0_2, arg1_2)
	if arg0_2._go == nil then
		PoolMgr.GetInstance():GetUI("ChangeSkinUI", true, function(arg0_3)
			arg0_2._go = arg0_3

			arg0_2._go:SetActive(false)

			local var0_3 = GameObject.Find("OverlayCamera/Overlay/UITop")

			arg0_2._go.transform:SetParent(var0_3.transform, false)

			arg0_2._spineContent = findTF(arg0_2._go, "ad/spine")
			arg0_2._mvContent = findTF(arg0_2._go, "ad/mv")
			arg0_2._live2dContent = findTF(arg0_2._go, "ad/live2d")

			arg1_2()
		end)
	end
end

function var0_0.preloadChangeAction(arg0_4, arg1_4, arg2_4)
	arg0_4._isloading = true

	local var0_4 = ShipGroup.GetChangeSkinAction(arg1_4)
	local var1_4 = "changeskin/" .. var0_4

	PoolMgr.GetInstance():GetPrefab(var1_4, "", true, function(arg0_5)
		if var1_4 then
			PoolMgr.GetInstance():ReturnPrefab(var1_4, "", arg0_5, false)
		end

		if arg2_4 then
			arg2_4()
		end

		arg0_4._isloading = false
	end)
end

function var0_0.isAble(arg0_6)
	return not arg0_6._isloading and not arg0_6._inPlaying
end

function var0_0.play(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if arg0_7._inPlaying then
		return
	end

	arg0_7._inPlaying = true
	arg0_7.changeIndex = ShipGroup.GetChangeSkinIndex(arg1_7)
	arg0_7.changeState = ShipGroup.GetChangeSkinState(arg1_7)
	arg0_7.changAction = ShipGroup.GetChangeSkinAction(arg1_7)
	arg0_7._loadObjectName = "changeskin/" .. arg0_7.changAction

	if arg0_7.changeState == var1_0 then
		PoolMgr.GetInstance():GetPrefab(arg0_7._loadObjectName, "", true, function(arg0_8)
			arg0_7._go:SetActive(true)

			arg0_7._loadObject = arg0_8
			arg0_7._spineUI = tf(arg0_8)

			arg0_7._spineUI:SetParent(arg0_7._spineContent, false)
			setActive(arg0_7._spineUI, true)

			arg0_7._spineAnimUI = GetComponent(findTF(arg0_7._spineUI, "ad/spine"), typeof(SpineAnimUI))

			local var0_8 = "change_" .. arg0_7.changeIndex

			arg0_7._spineAnimUI:SetAction(var0_8, 0)
			arg0_7._spineAnimUI:SetActionCallBack(function(arg0_9)
				if arg0_9 == "action" then
					if arg2_7 then
						arg2_7()
					end
				elseif arg0_9 == "finish" then
					if arg3_7 then
						arg3_7()
					end

					arg0_7:finish(arg4_7)
				else
					print("触发音效" .. arg0_9)
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg0_9)
				end
			end)
		end)
	elseif arg0_7.changeState == var2_0 then
		-- block empty
	elseif arg0_7.changeState == var3_0 then
		-- block empty
	end
end

function var0_0.finish(arg0_10, arg1_10)
	if LeanTween.isTweening(arg0_10._go) then
		LeanTween.cancel(arg0_10._go)
	end

	LeanTween.delayedCall(0.5, System.Action(function()
		if arg0_10._spineAnimUI then
			arg0_10._spineAnimUI:SetActionCallBack(nil)

			arg0_10._spineAnimUI = nil
		end

		if arg0_10._loadObject then
			PoolMgr.GetInstance():ReturnPrefab(arg0_10._loadObjectName, "", arg0_10._loadObject, true)
		end

		arg0_10._inPlaying = false

		if arg0_10._go then
			arg0_10._go:SetActive(false)
		end

		if arg1_10 then
			arg1_10()
		end
	end))
end
