local var0 = class("VoteAwardPtWindow", import("view.activity.Panels.PtAwardWindow"))

var0.TYPE_CURR = 1
var0.TYPE_ACC = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0.binder = arg2
	arg0.scrollPanel = arg0._tf:Find("frame/panel")
	arg0.UIlist = UIItemList.New(arg0._tf:Find("frame/panel/list"), arg0._tf:Find("frame/panel/list/tpl"))
	arg0.ptTF = arg0._tf:Find("frame/pt")
	arg0.totalTxt = arg0._tf:Find("frame/pt/Text"):GetComponent(typeof(Text))
	arg0.totalTitleTxt = arg0._tf:Find("frame/pt/title"):GetComponent(typeof(Text))
end

function var0.UpdateTitle(arg0, arg1)
	if arg1 == var0.TYPE_CURR then
		arg0.resTitle, arg0.cntTitle = i18n("vote_lable_curr_title_1"), i18n("vote_lable_curr_title_2")
	elseif arg1 == var0.TYPE_ACC then
		arg0.resTitle, arg0.cntTitle = i18n("vote_lable_acc_title_1"), i18n("vote_lable_acc_title_2")
	end
end

function var0.updateResIcon(arg0)
	return
end

return var0
