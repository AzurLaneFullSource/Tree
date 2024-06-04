local var0 = "zh-cn"
local var1 = require("Framework/lang/" .. var0)

function l10n(arg0)
	return var1[arg0] or arg0
end

function i18n(arg0, ...)
	local var0 = pg.gametip[arg0]

	if var0 then
		local var1 = var0.tip

		for iter0, iter1 in ipairs({
			...
		}) do
			var1 = string.gsub(var1, "$" .. iter0, iter1)
		end

		return var1
	else
		return i18n_not_find(arg0)
	end
end

function i18n_not_find(arg0)
	return "UndefinedLanguage:" .. arg0
end

function i18n1(arg0, ...)
	return string.format(l10n(arg0), ...)
end

function i18n2(arg0, ...)
	local var0 = pg.gameset_language_client[arg0]

	if var0 then
		local var1 = var0.value

		for iter0, iter1 in ipairs({
			...
		}) do
			var1 = string.gsub(var1, "$" .. iter0, iter1)
		end

		return var1
	else
		return arg0
	end
end
