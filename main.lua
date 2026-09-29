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

log('Loaded')
