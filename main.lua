local vanilla_enhancements = {
    'm_bonus', 'm_mult', 'm_wild', 'm_glass', 'm_steel', 'm_stone', 'm_gold', 'm_lucky'
}

local vanilla_seals = {'Gold', 'Red', 'Blue', 'Purple'}

local function log(message)
    sendDebugMessage(message, 'EvolutionaryDeck')
end

local function evolve(card, xp)
    local state = card.ability.evodeck

    if xp >= 3 and not state.enhancement then
        state.enhancement = true
        if card.config.center.key == 'c_base' then
            local key = SMODS.poll_enhancement({
                key = 'evodeck_enh_' .. card.playing_card,
                type_key = 'evodeck_enh_type_' .. card.playing_card,
                guaranteed = true,
                no_replace = true,
                options = vanilla_enhancements
            })
            if key and G.P_CENTERS[key] then
                card:set_ability(G.P_CENTERS[key])
                card.ability.evodeck = state
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Evolved!', colour = G.C.PURPLE})
                log('Card ' .. card.playing_card .. ' gained enhancement ' .. key .. ' at ' .. xp .. ' scored uses')
            end
        end
    end

    if xp >= 7 and not state.seal then
        state.seal = true
        if not card.seal then
            local key = SMODS.poll_seal({
                key = 'evodeck_seal_' .. card.playing_card,
                type_key = 'evodeck_seal_type_' .. card.playing_card,
                guaranteed = true,
                options = vanilla_seals
            })
            if key then
                card:set_seal(key)
                card.ability.evodeck = state
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Seal evolved!', colour = G.C.PURPLE})
                log('Card ' .. card.playing_card .. ' gained seal ' .. key .. ' at ' .. xp .. ' scored uses')
            end
        end
    end

    if xp >= 12 and not state.edition then
        state.edition = true
        if not card.edition then
            local key = SMODS.poll_edition({
                key = 'evodeck_edition_' .. card.playing_card,
                guaranteed = true,
                no_negative = true,
                options = {'e_foil', 'e_holo', 'e_polychrome'}
            })
            if key then
                card:set_edition(key, true)
                card.ability.evodeck = state
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Edition evolved!', colour = G.C.PURPLE})
                log('Card ' .. card.playing_card .. ' gained edition ' .. key .. ' at ' .. xp .. ' scored uses')
            end
        end
    end
end

local eval_card_ref = eval_card
function eval_card(card, context)
    local effects, post = eval_card_ref(card, context)
    if card and card.playing_card and not card.debuff and context and context.main_scoring and context.cardarea == G.play then
        card.ability.evodeck = card.ability.evodeck or {xp = 0}
        local state = card.ability.evodeck
        state.xp = (state.xp or 0) + 1
        log('Card ' .. card.playing_card .. ' scored; xp=' .. state.xp)
        evolve(card, state.xp)
        if state.xp < 12 then
            local next_level = state.xp < 3 and 3 or state.xp < 7 and 7 or 12
            card_eval_status_text(card, 'extra', nil, nil, nil,
                {message = 'XP ' .. state.xp .. '/' .. next_level, colour = G.C.PURPLE,
                    instant = true, no_juice = true})
        end
    end
    return effects, post
end

SMODS.DrawStep {
    key = 'evodeck_xp',
    order = 45,
    conditions = { vortex = false, facing = 'front', front_hidden = false },
    func = function(card)
        if not card.playing_card or not card.ability then return end

        local xp = math.min(card.ability.evodeck and card.ability.evodeck.xp or 0, 12)
        local colors = {G.C.CHIPS, G.C.RED, G.C.PURPLE}
        local radius, spacing, group_gap = 0.024, 0.056, 0.035
        local width = 11 * spacing + 2 * group_gap + 2 * radius
        local x = (card.T.w - width) / 2 + radius
        local y = card.T.h - 0.105

        love.graphics.push('all')
        prep_draw(card)
        for pip = 1, 12 do
            local group = pip <= 3 and 1 or pip <= 7 and 2 or 3
            local extra_gap = (pip > 3 and group_gap or 0) + (pip > 7 and group_gap or 0)
            local px = x + (pip - 1) * spacing + extra_gap
            local filled = pip <= xp
            local milestone = pip == 3 or pip == 7 or pip == 12

            if milestone then
                love.graphics.setColor(colors[group])
                love.graphics.circle('line', px, y, radius * 1.6)
            end
            love.graphics.setColor(filled and colors[group] or {0.08, 0.08, 0.10, 0.8})
            love.graphics.circle('fill', px, y, radius)
        end
        love.graphics.pop()
    end,
}

log('Loaded')
