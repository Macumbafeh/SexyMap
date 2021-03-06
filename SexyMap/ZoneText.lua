local parent = SexyMap
local modName = "ZoneText"
local media = LibStub("LibSharedMedia-3.0")
local mod = SexyMap:NewModule(modName)
local L = LibStub("AceLocale-3.0"):GetLocale("SexyMap")
local db

local hideValues = {
	["always"] = L["Always"],
	["never"] = L["Never"],
	["hover"] = L["On hover"]	
}
	
local options = {
	type = "group",
	name = modName,
	args = {
		xOffset = {
			type = "range",
			name = L["Horizontal position"],
			min = -250,
			max = 250,
			step = 1,
			bigStep = 5,
			get = function() return db.xOffset end,
			set = function(info, v) db.xOffset = v; mod:Update() end
		},
		yOffset = {
			type = "range",
			name = L["Vertical position"],
			min = -250,
			max = 250,
			step = 1,
			bigStep = 5,
			get = function() return db.yOffset end,
			set = function(info, v) db.yOffset = v; mod:Update() end
		},
		width = {
			type = "range",
			name = L["Width"],
			min = 50,
			max = 400,
			step = 1,
			bigStep = 5,
			get = function() return MinimapZoneTextButton:GetWidth() end,
			set = function(info, v) db.width = v; mod:Update() end
		},
		show = {
			type = "multiselect",
			name = ("Show %s..."):format("zone text"),
			values = hideValues,
			order = 1,
			get = function(info, v)
				return db.show == v
			end,
			set = function(info, v)
				db.show = v
				mod:SetOnHover()
			end
		},
		bgColor = {
			type = "color",
			name = L["Background color"],
			hasAlpha = true,
			get = function()
				return db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a
			end,
			set = function(info, r, g, b, a)
				db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a = r, g, b, a
				mod:Update()
			end
		},
		borderColor = {
			type = "color",
			name = L["Border color"],
			hasAlpha = true,
			get = function()
				return db.borderColor.r, db.borderColor.g, db.borderColor.b, db.borderColor.a
			end,
			set = function(info, r, g, b, a)
				db.borderColor.r, db.borderColor.g, db.borderColor.b, db.borderColor.a = r, g, b, a
				mod:Update()
			end
		},
		font = {
			type = "select",
			name = L["Font"],
			dialogControl = 'LSM30_Font',
			order = 106,
			values = AceGUIWidgetLSMlists.font,
			get = function() return db.font end,
			set = function(info, v) 
				db.font = v
				mod:Update()
			end
		},
		fontSize = {
			type = "range",
			name = L["Font Size"],
			min = 4,				
			max = 30,
			step = 1,
			bigStep = 1,
			get = function() return db.fontsize end,
			set = function(info, v) 
				db.fontsize = v
				mod:Update()
			end		
		},
		fontColor = {
			type = "color",
			name = L["Font color"],
			hasAlpha = true,
			get = function()
				return db.fontColor.r, db.fontColor.g, db.fontColor.b, db.fontColor.a
			end,
			set = function(info, r, g, b, a)
				db.fontColor.r, db.fontColor.g, db.fontColor.b, db.fontColor.a = r, g, b, a
				mod:Update()
			end		
		}		
	}
}

local defaults = {
	profile = {
		xOffset = 0,
		yOffset = 0,
		bgColor = {r = 0, g = 0, b = 0, a = 1},
		borderColor = {r = 0, g = 0, b = 0, a = 1},
		fontColor = {},
		show = "always"
	}
}
function mod:OnInitialize()
	self.db = parent.db:RegisterNamespace(modName, defaults)
	db = self.db.profile
	parent:RegisterModuleOptions(modName, options, "Zone Button")
	MinimapToggleButton:ClearAllPoints()
	MinimapToggleButton:SetParent(MinimapZoneTextButton)
	MinimapToggleButton:SetPoint("LEFT", MinimapZoneTextButton, "RIGHT", -3, 0)
	
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("CENTER")
	MinimapZoneTextButton:SetHeight(26)
	MinimapZoneTextButton:SetBackdrop(parent.backdrop)
	
	self:Update()
	self:SetOnHover()
end

function mod:SetOnHover()
	parent:UnregisterHoverButton(MinimapZoneTextButton)
	MinimapZoneTextButton:Show()
	MinimapZoneTextButton:SetAlpha(1)
	if db.show == "never" then
		MinimapZoneTextButton:Hide()
	elseif db.show == "hover" then
		parent:RegisterHoverButton(MinimapZoneTextButton)
	end
end

function mod:Update()
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("BOTTOM", Minimap, "TOP", db.xOffset, db.yOffset)
	MinimapZoneTextButton:SetWidth(db.width or MinimapZoneTextButton:GetWidth())
	if db.fontsize then
		MinimapZoneTextButton:SetHeight(db.fontsize * 1.5 + 6)
	end
	MinimapZoneTextButton:SetBackdropColor(db.bgColor.r, db.bgColor.g, db.bgColor.b, db.bgColor.a)
	MinimapZoneTextButton:SetBackdropBorderColor(db.borderColor.r, db.borderColor.g, db.borderColor.b, db.borderColor.a)
	local a, b, c = MinimapZoneText:GetFont()
	MinimapZoneText:SetFont(db.font and media:Fetch("font", db.font) or a, db.fontsize or b, c)
	if db.fontColor.r then
		MinimapZoneText:SetTextColor(db.fontColor.r, db.fontColor.g, db.fontColor.b, db.fontColor.a)
	end
end
