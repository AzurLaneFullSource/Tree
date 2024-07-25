local var0_0 = class("MapBuilderPermanent", import(".MapBuilder"))

function var0_0.OnLoaded(arg0_1)
	setParent(arg0_1._tf, arg0_1.float)
end

function var0_0.OnShow(arg0_2)
	var0_0.super.OnShow(arg0_2)
	setActive(arg0_2.sceneParent.float, true)
end

function var0_0.OnHide(arg0_3)
	arg0_3.sceneParent:HideBtns()
	setActive(arg0_3.sceneParent.float, false)
	var0_0.super.OnHide(arg0_3)
end

function var0_0.UpdateButtons(arg0_4)
	arg0_4.sceneParent:updateDifficultyBtns()
	arg0_4.sceneParent:updateActivityBtns()
	arg0_4.sceneParent:UpdateSwitchMapButton()
end

function var0_0.UpdateMapItems(arg0_5)
	var0_0.super.UpdateMapItems(arg0_5)

	local var0_5 = arg0_5.contextData.map
	local var1_5 = var0_5:getConfig("cloud_suffix")

	if var1_5 == "" then
		setActive(arg0_5.sceneParent.clouds, false)
	else
		setActive(arg0_5.sceneParent.clouds, true)

		for iter0_5, iter1_5 in ipairs(var0_5:getConfig("clouds_pos")) do
			local var2_5 = arg0_5.sceneParent.cloudRTFs[iter0_5]
			local var3_5 = var2_5:GetComponent(typeof(Image))

			var3_5.enabled = false

			GetSpriteFromAtlasAsync("clouds/cloud_" .. iter0_5 .. "_" .. var1_5, "", function(arg0_6)
				if arg0_5:CheckState(var0_0.STATES.DESTROY) then
					return
				end

				if not IsNil(var3_5) and var0_5 == arg0_5.contextData.map then
					var3_5.enabled = true
					var3_5.sprite = arg0_6

					var3_5:SetNativeSize()

					arg0_5.sceneParent.cloudRects[iter0_5] = var2_5.rect.width
				end
			end)
		end
	end
end

return var0_0
