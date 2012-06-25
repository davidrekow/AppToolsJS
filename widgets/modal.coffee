## AppTools Modal Widget & API
class ModalAPI extends CoreWidgetAPI

    @mount = 'modal'
    @events = ['MODAL_READY', 'MODAL_API_READY']

    constructor: (apptools, widget, window) ->

        @_state =
            modals: []
            modals_by_id: {}
            init: false

        @create = (target, trigger, options) =>

            options = JSON.parse(target.getAttribute('data-options')) if target.hasAttribute('data-options')

            modal = new Modal(target, trigger, options)
            id = modal._state.element_id

            # one line, lol - push returns new length, minus 1 = newest index
            @_state.modals_by_id[id] = @_state.modals.push(modal) - 1

            return modal._init()

        @destroy = (modal) =>

            id = modal._state.element_id

            @_state.modals.splice @_state.modals_by_id[id], 1
            delete @_state.modals_by_id[id]

            document.body.removeChild(Util.get(id))

            return modal

        @enable = (modal) =>

            trigger = Util.get(modal._state.trigger_id)
            Util.bind(trigger, 'mousedown', modal.open, false)

            return modal

        @disable = (modal) =>

            Util.unbind(Util.get(modal._state.trigger_id))

            return modal

        @_init = () =>

            modals = Util.get 'pre-modal'
            @enable(@create(modal, Util.get('a-'+modal.getAttribute('id')))) for modal in modals

            return @_state.init = true


class Modal extends CoreWidget

    constructor: (target, trigger, options) ->

        @_state =

            cached_id: target.getAttribute('id')        # source div ID
            trigger_id: trigger.getAttribute('id')
            element_id: null
            overlay: null

            active: false
            init: false

            config:

                initial:                                # style props at animate start
                    width: '0px'
                    height: '0px'
                    top: window.innerHeight/2 + 'px'
                    left: window.innerHeight/2 + 'px'

                ratio:                                  # 0-1, final size vs. window inner
                    x: 0.4
                    y: 0.4

                template: [                             # someday I'll write the render API
                    '<div id="modal-dialog" style="opacity: 0;" class="fixed dropshadow">',
                        '<div id="modal-fade" style="opacity: 0">',
                            '<div id="modal-content">&nbsp;</div>',
                            '<div id="modal-ui" class="absolute">',
                                '<div id="modal-title" class="absolute"></div>',
                                '<div id="modal-close" class="absolute">X</div>',
                            '</div>',
                        '</div>',
                    '</div>'
                ].join('\n')

                rounded: true

        @_state.config = Util.extend(true, @_state.config, JSON.parse(target.getAttribute('data-options')))

        @calc = () =>

            # returns prepared modal property object
            css = {}
            r = @_state.config.ratio
            wW = window.innerWidth
            wH = window.innerHeight
            dW = Math.floor r.x*wW
            dH = Math.floor r.y*wH

            css.width = dW+'px'
            css.height = dH+'px'
            css.left = Math.floor (wW-dW)/2
            css.top = Math.floor (wH-dH)/2

            return css

        @make = () =>

            template = @_state.config.template

            # make & append document fragment from template string
            range = document.createRange()
            range.selectNode(doc = document.getElementsByTagName('div').item(0))    # select document
            d = range.createContextualFragment(template)                            # parse html string
            document.body.appendChild d

            # style & customize modal dialogue
            dialog = Util.get 'modal-dialog'
            title = Util.get 'modal-title'
            content = Util.get 'modal-content'
            ui = Util.get 'modal-ui'
            close_x = Util.get 'modal-close'
            fade = Util.get 'modal-fade'
            id = @_state.cached_id

            dialog.classList.add dialog.getAttribute 'id'
            dialog.setAttribute 'id', id+'-modal-dialog'
            dialog.classList.add 'rounded' if @_state.config.rounded
            dialog.style[prop] = val for prop, val of @_state.config.initial

            content.classList.add content.getAttribute 'id'
            content.setAttribute 'id', id+'-modal-content'
            content.style.height = @calc().height
            content.innerHTML = (t = Util.get(id)).innerHTML

            title.classList.add title.getAttribute 'id'
            title.setAttribute 'id', id+'-modal-title'
            title.innerHTML = t.getAttribute 'data-title'

            ui.classList.add ui.getAttribute 'id'
            ui.setAttribute 'id', id+'-modal-ui'

            close_x.classList.add close_x.getAttribute 'id'
            close_x.setAttribute 'id', id+'-modal-close'

            fade.classList.add fade.getAttribute 'id'
            fade.setAttribute 'id', id+'-modal-fade'

            # stash a reference to dialogue element
            @_state.element_id = dialog.getAttribute 'id'

            return dialog

        @open = () =>

            id = @_state.cached_id
            dialog = Util.get(@_state.element_id)
            close_x = Util.get(id+'-modal-close')
            @_state.active = true

            # overlay!
            overlay = @_state.overlay or @prepare_overlay('modal')
            @_state.overlay = overlay
            if not Util.get(overlay)
                document.body.appendChild(overlay)

            # extend default animation params with callbacks
            fade_animation = @animation
            dialog_animation = @animation
            overlay_animation = @animation

            dialog_animation.complete = () =>
                $('#'+id+'-modal-fade').animate opacity: 1, fade_animation

            # get final params
            final = @calc()
            final.opacity = 1

            # show & bind close()
            dialog.style.display = 'block'
            overlay.style.display = 'block'

            $(overlay).animate opacity: 0.5, overlay_animation
            $(dialog).animate final, dialog_animation

            Util.bind([close_x, overlay], 'mousedown', @close)

            return dialog

        @close = () =>

            id = @_state.cached_id
            @_state.active = false

            overlay = @_state.overlay
            dialog = Util.get @_state.element_id

            Util.unbind([Util.get(id+'-modal-close'), overlay], 'mousedown')

            midpoint = Util.extend({}, @_state.config.initial, opacity: 0.5)


            Util.get(id+'-modal-content').style.overflow = 'hidden' # disable scroll during animation
            $('#'+id+'-modal-fade').animate({opacity: 0}, {
                duration: 300,
                complete: () =>
                    dialog.classList.remove 'dropshadow'
                    dialog.classList.remove 'rounded'
                    dialog.style.padding = '0px'

                    $(dialog).animate(midpoint, {
                        duration: 300,
                        complete: () =>
                            $(dialog).animate({opacity: 0}, {
                                duration: 250,
                                complete: () =>
                                    dialog.style.display = 'none'
                                    dialog.style[prop] = val for prop, val of @_state.config.initial
                                    $(@_state.overlay).animate({opacity: 0}, {
                                        duration: 300,
                                        complete: () =>
                                            @_state.overlay.style.display = 'none'
                                        }
                                    )
                                }
                            )
                        }
                    )
                }
            )

            return dialog

        @_init = () =>

            dialog = @make()
            trigger.removeAttribute('href')

            @_state.init = true
            $.apptools.events.trigger 'MODAL_READY', @

            return @



@__apptools_preinit.abstract_base_classes.push Modal
@__apptools_preinit.abstract_base_classes.push ModalAPI
@__apptools_preinit.deferred_core_modules.push {module: ModalAPI, package: 'widgets'}