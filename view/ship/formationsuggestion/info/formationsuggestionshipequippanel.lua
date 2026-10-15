local var0_0 = class("FormationSuggestionShipEquipPanel", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiCopyText, i18n("formation_suggestion_info_equip_copy"))
	setScrollText(arg0_2.uiSpUnownedText, i18n("equipcode_equipment_unowned"))
	onButton(arg0_2, arg0_2.uiCopyBtn, function()
		local var0_3 = {}

		for iter0_3, iter1_3 in ipairs(arg0_2.equipDataList[1]) do
			table.insert(var0_3, Equipment.New({
				id = iter1_3[1],
				config_id = iter1_3[1] + iter1_3[2],
				skinId = iter1_3[1]
			}))
		end

		local var1_3 = SpWeapon.New({
			id = arg0_2.equipDataList[2][1][1] + arg0_2.equipDataList[2][1][2]
		})
		local var2_3 = buildEquipAndSpCode(var0_3, var1_3)

		UniPasteBoard.SetClipBoardString(var2_3)
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_export_success"))
	end, SFX_PANEL)

	arg0_2.equipItemList = UIItemList.New(arg0_2.uiEquipParent, arg0_2.uiEquipItem)
end

function var0_0.SetData(arg0_4, arg1_4)
	arg0_4.equipDataList = arg1_4

	local var0_4 = arg1_4[1]

	arg0_4.equipItemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = var0_4[arg1_5 + 1]
			local var1_5 = EquipmentTools.HasEquipByGroup(pg.equip_data_template[var0_5[1]].group)
			local var2_5 = var1_5 and var0_5[1] + var0_5[2] or var0_5[1]
			local var3_5 = Equipment.New({
				id = var2_5,
				config_id = var2_5,
				skinId = var2_5
			})

			updateEquipment(arg2_5, var3_5)
			setActive(findTF(arg2_5, "unOwned"), not var1_5)
			setScrollText(findTF(arg2_5, "unOwned/Text"), i18n("equipcode_equipment_unowned"))
			onButton(arg0_4, arg2_5, function()
				arg0_4:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
					mediator = EquipmentInfoMediator,
					viewComponent = EquipmentInfoLayer,
					data = {
						equipmentId = var2_5,
						type = EquipmentInfoMediator.TYPE_DISPLAY
					}
				}))
			end)
		end
	end)
	arg0_4.equipItemList:align(#var0_4)

	local var1_4 = arg1_4[2][1]
	local var2_4 = EquipmentTools.HasBaseSpWeapon(var1_4[1])
	local var3_4 = var2_4 and var1_4[1] + var1_4[2] or var1_4[1]
	local var4_4 = SpWeapon.New({
		id = var3_4
	})

	UpdateSpWeaponSlot(arg0_4.uiSpTf, var4_4)
	setActive(arg0_4.uiSpUnownedGo, not var2_4)
	onButton(arg0_4, arg0_4.uiSpTf, function()
		arg0_4:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			mediator = SpWeaponInfoMediator,
			viewComponent = SpWeaponInfoLayer,
			data = {
				spWeaponConfigId = var3_4,
				type = SpWeaponInfoLayer.TYPE_DISPLAY
			}
		}))
	end)
end

function var0_0.willExit(arg0_8)
	arg0_8.equipItemList:Dispose()
	arg0_8:detach()
end

return var0_0
