local var0 = class("EquipmentSkinLayer", import("..base.BaseUI"))

var0.DISPLAY = 1
var0.REPLACE = 2

function var0.getUIName(arg0)
	return "EquipmentSkinInfoUI"
end

function var0.setShip(arg0, arg1)
	arg0.shipVO = arg1
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, arg0.contextData.weight and {
		weight = arg0.contextData.weight
	} or {})

	arg0.displayPanel = arg0:findTF("display")

	setActive(arg0.displayPanel, false)

	arg0.displayActions = arg0.displayPanel:Find("actions")
	arg0.skinViewOnShipTF = arg0:findTF("replace/equipment_on_ship")
	arg0.skinViewTF = arg0:findTF("replace/equipment")
	arg0.replacePanel = arg0:findTF("replace")

	setActive(arg0.replacePanel, false)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0, arg0._tf:Find("display/top/btnBack"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("actions/cancel_button", arg0.replacePanel), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("actions/action_button_2", arg0.replacePanel), function()
		if not arg0.contextData.oldShipInfo then
			arg0:emit(EquipmentSkinMediator.ON_EQUIP)
		else
			arg0:emit(EquipmentSkinMediator.ON_EQUIP_FORM_SHIP)
		end
	end, SFX_PANEL)

	local var0 = arg0.contextData.mode or var0.DISPLAY

	if var0 == var0.REPLACE and arg0.shipVO then
		arg0:initReplace()
	elseif var0 == var0.DISPLAY then
		arg0:initDisplay()
	end
end

function var0.initDisplay(arg0)
	setActive(arg0.displayPanel, true)
	setActive(arg0.replacePanel, false)

	if arg0.shipVO then
		arg0:initDisplay4Ship()
	else
		eachChild(arg0.displayActions, function(arg0)
			local var0 = arg0.gameObject.name == "confirm"

			setActive(arg0, var0)

			if var0 then
				onButton(arg0, arg0, function()
					arg0:emit(var0.ON_CLOSE)
				end, SFX_PANEL)
			end
		end)
	end

	arg0:updateSkinView(arg0.displayPanel, arg0.contextData.skinId)
end

function var0.initDisplay4Ship(arg0)
	eachChild(arg0.displayActions, function(arg0)
		local var0 = arg0.gameObject.name

		setActive(arg0, var0 ~= "confirm")
		onButton(arg0, arg0, function()
			if var0 == "unload" then
				arg0:emit(EquipmentSkinMediator.ON_UNEQUIP)
			elseif var0 == "replace" then
				arg0:emit(EquipmentSkinMediator.ON_SELECT)
			end
		end, SFX_PANEL)
	end)
end

function var0.initReplace(arg0)
	setActive(arg0.displayPanel, false)
	setActive(arg0.replacePanel, true)

	local var0 = arg0.contextData.pos
	local var1 = arg0.shipVO:getEquipSkin(var0) or 0
	local var2 = arg0.contextData.skinId

	arg0:updateSkinView(arg0.skinViewOnShipTF, var1)

	if arg0.contextData.oldShipInfo then
		local var3 = arg0.contextData.oldShipInfo

		arg0:updateSkinView(arg0.skinViewTF, var2, var3)
	else
		arg0:updateSkinView(arg0.skinViewTF, var2)
	end
end

function var0.updateSkinView(arg0, arg1, arg2, arg3)
	local var0 = arg2 ~= 0
	local var1 = arg0:findTF("empty", arg1)
	local var2 = arg0:findTF("info", arg1)

	if var1 then
		setActive(var1, not var0)
	end

	setActive(var2, var0)

	arg1:GetComponent(typeof(Image)).enabled = var0

	if var0 then
		local var3 = pg.equip_skin_template[arg2]

		assert(var3, "miss config equip_skin_template >> " .. arg2)

		local var4 = arg0:findTF("info/display_panel/name_container/name", arg1):GetComponent(typeof(Text))
		local var5 = arg0:findTF("info/display_panel/desc", arg1):GetComponent(typeof(Text))

		var4.text = var3.name
		var5.text = var3.desc

		local var6 = _.map(var3.equip_type, function(arg0)
			return EquipType.Type2Name2(arg0)
		end)

		setScrollText(arg0:findTF("info/display_panel/equip_type/mask/Text", arg1), table.concat(var6, ","))

		local var7 = arg0:findTF("info/play_btn", arg1)

		setActive(var7, true)
		onButton(arg0, var7, function()
			arg0:emit(EquipmentSkinMediator.ON_PREVIEW, arg2)
		end, SFX_PANEL)
		updateDrop(arg0:findTF("info/equip", arg1), Drop.New({
			type = DROP_TYPE_EQUIPMENT_SKIN,
			id = arg2
		}))

		local var8 = arg0:findTF("info/head", arg1)

		if var8 then
			setActive(var8, arg3)

			if arg3 then
				assert(arg3.id, "old ship id is nil")
				assert(arg3.pos, "old ship pos is nil")

				local var9 = getProxy(BayProxy):getShipById(arg3.id)

				if var9 then
					setImageSprite(var8:Find("Image"), LoadSprite("qicon/" .. var9:getPainting()))
				end
			end
		end
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.UIMain)
end

return var0
