module PDF
  module Impose
    module Ext
      module Reference
        def extract_content_stream
          content = stream
          content = content.filtered_stream if content.respond_to?(:filtered_stream)

          if data[:Filter]
            options = []

            if data[:DecodeParams].is_a?(Hash)
              options = [data[:DecodeParams]]
            elsif data[:DecodeParams]
              options = data[:DecodeParams]
            end

            Array(data[:Filter]).each_with_index do |filter, index|
              content = PDF::Reader::Filter.
                        with(filter, options[index]).filter(content)
            end
          end

          content
        end
      end

      module Page
        def merge_object_resources(object)
          object_resources = document.deref(object.data[:Resources])

          object_resources.keys.each do |resource|
            case object_resources[resource]
            when ::Hash then
              resources[resource] ||= {}
              resources[resource].update(object_resources[resource])
            when ::Array then
              resources[resource] ||= []
              resources[resource] |= object_resources[resource]
            when PDF::Core::Reference then
              resources[resource] = object_resources[resource]
            else
              klass = object_resources[resource].class
              abort "unknown resource type #{klass} for #{resource}"
            end
          end
        end

        def import_page(reader, page_number, dx, dy, width, height, mirror)
          return unless page_number

          ref = reader.objects.page_references[page_number]
          return unless ref

          object = document.state.store.
                   send(:load_object_graph, reader.objects, ref)

          merge_object_resources object

          contents = object.data[:Contents]
          contents = [contents] unless contents.is_a?(Array)

          contents.each do |content|
            content = content.extract_content_stream
            box = object.data[:MediaBox]

            scale = 1.0
            width_ratio = width.to_f / box[2]
            height_ratio = height.to_f / box[3]

            scale = [width_ratio, height_ratio].min

            document.save_graphics_state do
              document.translate dx, dy
              document.scale scale

              if mirror
                document.translate box[2], box[3]
                document.rotate 180
              end

              document.add_content content
            end
          end
        end
      end
    end
  end
end

require 'pdf/core'

PDF::Core::Reference.include PDF::Impose::Ext::Reference
PDF::Core::Page.include PDF::Impose::Ext::Page
