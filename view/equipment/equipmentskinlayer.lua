local var0_0 = class("EquipmentSkinLayer", import("..base.BaseUI"))

var0_0.DISPLAY = 1
var0_0.REPLACE = 2

function var0_0.getUIName(arg0_1)
	return "EquipmentSkinInfoUI"
end

function var0_0.setShip(arg0_2, arg1_2)
	arg0_2.shipVO = arg1_2
end

function var0_0.init(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, arg0_3.contextData.weight and {
		weight = arg0_3.contextData.weight
	} or {})

	arg0_3.displayPanel = arg0_3:findTF("display")

	setActive(arg0_3.displayPanel, false)

	arg0_3.displayActions = arg0_3.displayPanel:Find("actions")
	arg0_3.skinViewOnShipTF = arg0_3:findTF("replace/equipment_on_ship")
	arg0_3.skinViewTF = arg0_3:findTF("replace/equipment")
	arg0_3.replacePanel = arg0_3:findTF("replace")

	setActive(arg0_3.replacePanel, false)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4._tf:Find("display/top/btnBack"), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("actions/cancel_button", arg0_4.replacePanel), function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("actions/action_button_2", arg0_4.replacePanel), function()
		if not arg0_4.contextData.oldShipInfo then
			arg0_4:emit(EquipmentSkinMediator.ON_EQUIP)
		else
			arg0_4:emit(EquipmentSkinMediator.ON_EQUIP_FORM_SHIP)
		end
	end, SFX_PANEL)

	local var0_4 = arg0_4.contextData.mode or var0_0.DISPLAY

	if var0_4 == var0_0.REPLACE and arg0_4.shipVO then
		arg0_4:initReplace()
	elseif var0_4 == var0_0.DISPLAY then
		arg0_4:initDisplay()
	end
end

function var0_0.initDisplay(arg0_9)
	setActive(arg0_9.displayPanel, true)
	setActive(arg0_9.replacePanel, false)

	if arg0_9.shipVO then
		arg0_9:initDisplay4Ship()
	else
		eachChild(arg0_9.displayActions, function(arg0_10)
			local var0_10 = arg0_10.gameObject.name == "confirm"

			setActive(arg0_10, var0_10)

			if var0_10 then
				onButton(arg0_9, arg0_10, function()
					arg0_9:emit(var0_0.ON_CLOSE)
				end, SFX_PANEL)
			end
		end)
	end

	arg0_9:updateSkinView(arg0_9.displayPanel, arg0_9.contextData.skinId)
end

function var0_0.initDisplay4Ship(arg0_12)
	eachChild(arg0_12.displayActions, function(arg0_13)
		local var0_13 = arg0_13.gameObject.name

		setActive(arg0_13, var0_13 ~= "confirm")
		onButton(arg0_12, arg0_13, function()
			if var0_13 == "unload" then
				arg0_12:emit(EquipmentSkinMediator.ON_UNEQUIP)
			elseif var0_13 == "replace" then
				arg0_12:emit(EquipmentSkinMediator.ON_SELECT)
			end
		end, SFX_PANEL)
	end)
end

function var0_0.initReplace(arg0_15)
	setActive(arg0_15.displayPanel, false)
	setActive(arg0_15.replacePanel, true)

	local var0_15 = arg0_15.contextData.pos
	local var1_15 = arg0_15.shipVO:getEquipSkin(var0_15) or 0
	local var2_15 = arg0_15.contextData.skinId

	arg0_15:updateSkinView(arg0_15.skinViewOnShipTF, var1_15)

	if arg0_15.contextData.oldShipInfo then
		local var3_15 = arg0_15.contextData.oldShipInfo

		arg0_15:updateSkinView(arg0_15.skinViewTF, var2_15, var3_15)
	else
		arg0_15:updateSkinView(arg0_15.skinViewTF, var2_15)
	end
end

function var0_0.updateSkinView(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg2_16 ~= 0
	local var1_16 = arg0_16:findTF("empty", arg1_16)
	local var2_16 = arg0_16:findTF("info", arg1_16)

	if var1_16 then
		setActive(var1_16, not var0_16)
	end

	setActive(var2_16, var0_16)

	arg1_16:GetComponent(typeof(Image)).enabled = var0_16

	if var0_16 then
		local var3_16 = pg.equip_skin_template[arg2_16]

		assert(var3_16, "miss config equip_skin_template >> " .. arg2_16)

		local var4_16 = arg0_16:findTF("info/display_panel/name_container/name", arg1_16):GetComponent(typeof(Text))
		local var5_16 = arg0_16:findTF("info/display_panel/desc", arg1_16):GetComponent(typeof(Text))

		var4_16.text = var3_16.name
		var5_16.text = var3_16.desc

		local var6_16 = _.map(var3_16.equip_type, function(arg0_17)
			return EquipType.Type2Name2(arg0_17)
		end)

		setScrollText(arg0_16:findTF("info/display_panel/equip_type/mask/Text", arg1_16), table.concat(var6_16, ","))

		local var7_16 = arg0_16:findTF("info/play_btn", arg1_16)

		setActive(var7_16, true)
		onButton(arg0_16, var7_16, function()
			arg0_16:emit(EquipmentSkinMediator.ON_PREVIEW, arg2_16)
		end, SFX_PANEL)
		updateDrop(arg0_16:findTF("info/equip", arg1_16), Drop.New({
			type = DROP_TYPE_EQUIPMENT_SKIN,
			id = arg2_16
		}))

		local var8_16 = arg0_16:findTF("info/head", arg1_16)

		if var8_16 then
			setActive(var8_16, arg3_16)

			if arg3_16 then
				assert(arg3_16.id, "old ship id is nil")
				assert(arg3_16.pos, "old ship pos is nil")

				local var9_16 = getProxy(BayProxy):getShipById(arg3_16.id)

				if var9_16 then
					setImageSprite(var8_16:Find("Image"), LoadSprite("qicon/" .. var9_16:getPainting()))
				end
			end
		end
	end
end

function var0_0.willExit(arg0_19)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_19._tf, arg0_19.UIMain)
end

return var0_0
