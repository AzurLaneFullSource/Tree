local var0_0 = "zh-cn"
local var1_0 = require("Framework/lang/" .. var0_0)

function l10n(arg0_1)
	return var1_0[arg0_1] or arg0_1
end

function i18n(arg0_2, ...)
	local var0_2 = pg.gametip[arg0_2]

	if var0_2 then
		local var1_2 = var0_2.tip

		for iter0_2, iter1_2 in ipairs({
			...
		}) do
			var1_2 = string.gsub(var1_2, "$" .. iter0_2, iter1_2)
		end

		return var1_2
	else
		return i18n_not_find(arg0_2)
	end
end

function i18n_not_find(arg0_3)
	return "UndefinedLanguage:" .. arg0_3
end

function i18n1(arg0_4, ...)
	return string.format(l10n(arg0_4), ...)
end

function i18n2(arg0_5, ...)
	local var0_5 = pg.gameset_language_client[arg0_5]

	if var0_5 then
		local var1_5 = var0_5.value

		for iter0_5, iter1_5 in ipairs({
			...
		}) do
			var1_5 = string.gsub(var1_5, "$" .. iter0_5, iter1_5)
		end

		return var1_5
	else
		return arg0_5
	end
end
