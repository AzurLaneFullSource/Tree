pg = pg or {}
pg.RepairResMgr = singletonClass("RepairResMgr")

local var0_0 = pg.RepairResMgr

var0_0.TYPE_DEFAULT_RES = 2
var0_0.TYPE_L2D = 4
var0_0.TYPE_PAINTING = 8
var0_0.TYPE_CIPHER = 16
var0_0.TYPE_CV = 32

function var0_0.Init(arg0_1, arg1_1)
	LoadAndInstantiateAsync("ui", "RepairUI", function(arg0_2)
		arg0_1._go = arg0_2
		arg0_1._tf = arg0_1._go.transform

		arg0_1._go:SetActive(false)

		arg0_1.contentTxt = arg0_1._tf:Find("window/content/Text"):GetComponent(typeof(Text))
		arg0_1.parentTr = pg.UIMgr.GetInstance().OverlayToast

		arg0_1._go.transform:SetParent(arg0_1.parentTr, false)

		arg0_1.closeBtn = arg0_1._tf:Find("window/top/btnBack")
		arg0_1.btns = {
			arg0_1:InitDefaultResBtn(),
			arg0_1:InitL2dBtn(),
			arg0_1:InitPaintingBtn(),
			arg0_1:InitCipherBtn(),
			arg0_1:InitCvBtn()
		}
		arg0_1.uiItemList = UIItemList.New(arg0_1._tf:Find("window/buttons"), arg0_1._tf:Find("window/buttons/custom_button_1"))

		setText(arg0_1._tf:Find("window/top/title"), i18n("msgbox_repair_title"))
		arg1_1()
	end, true, true)
end

function var0_0.InitDefaultResBtn(arg0_3)
	return {
		type = var0_0.TYPE_DEFAULT_RES,
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitL2dBtn(arg0_5)
	return {
		type = var0_0.TYPE_L2D,
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitPaintingBtn(arg0_7)
	return {
		type = var0_0.TYPE_PAINTING,
		text = i18n("msgbox_repair_painting"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-painting.csv") then
				BundleWizard.Inst:GetGroupMgr("PAINTING"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitCipherBtn(arg0_9)
	return {
		type = var0_0.TYPE_CIPHER,
		text = i18n("msgbox_repair_cipher"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-cipher.csv") then
				BundleWizard.Inst:GetGroupMgr("CIPHER"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.InitCvBtn(arg0_11)
	return {
		type = var0_0.TYPE_CV,
		text = i18n("msgbox_repair_cv"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-cv.csv") then
				BundleWizard.Inst:GetGroupMgr("CV"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0_0.Repair(arg0_13, arg1_13)
	local var0_13 = arg1_13 or bit.bor(var0_0.TYPE_DEFAULT_RES, var0_0.TYPE_L2D, var0_0.TYPE_PAINTING, var0_0.TYPE_CIPHER, var0_0.TYPE_CV)
	local var1_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.btns) do
		if bit.band(iter1_13.type, var0_13) > 0 then
			table.insert(var1_13, iter1_13)
		end
	end

	arg0_13:Show(var1_13)
end

function var0_0.Show(arg0_14, arg1_14)
	pg.DelegateInfo.New(arg0_14)
	arg0_14._go:SetActive(true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	arg0_14.uiItemList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg1_14[arg1_15 + 1]

			setText(arg2_15:Find("Text"), var0_15.text)
			onButton(arg0_14, arg2_15, function()
				if var0_15.onCallback then
					var0_15.onCallback()
				end

				arg0_14:Hide()
			end, SFX_PANEL)
		end
	end)
	arg0_14.uiItemList:align(#arg1_14)

	arg0_14.contentTxt.text = i18n("resource_verify_warn")

	onButton(arg0_14, arg0_14._tf, function()
		arg0_14:Hide()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.closeBtn, function()
		arg0_14:Hide()
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_19)
	pg.DelegateInfo.Dispose(arg0_19)
	arg0_19._go:SetActive(false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf, arg0_19.parentTr)
end
