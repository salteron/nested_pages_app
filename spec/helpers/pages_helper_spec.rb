require 'spec_helper'

describe PagesHelper do
  describe "content formating" do

  	context "bold" do
  		it "bolds a simple string" do
				expect(replace_with_bold("**Hello, World!**")).to eq(
					"<b>Hello, World!</b>"
				) 
  		end

  		it "bolds a sequence of the two" do
  			expect(replace_with_bold("**Hello**, **World!**")).to eq(
          "<b>Hello</b>, <b>World!</b>"
        )
  		end

      it "doesn't bold when wrong syntax used" do
        expect(replace_with_bold("**Hell*o*")).to eq(
          "**Hell*o*")
        expect(replace_with_bold("**Hello*")).to eq(
          "**Hello*")
      end
  	end

    context "italic" do
      it "makes a simple string italic" do
        expect(replace_with_italic("\\\\Hello, World!\\\\")).to eq(
          "<i>Hello, World!</i>")
      end

      # .. 
    end

    context "references" do
      it "makes a reference" do
        expect(replace_with_href("Visit ((/name1/name2 title2)) page!",
          "www.example.com")).to eq(
          "Visit <a href='www.example.com/name1/name2'>title2</a> page!")
      end
    end

    context "integrated" do
      it "bolds and makes italic" do
        expect(
          replace_with_italic(replace_with_bold('**Hello, \\\\Wo\\\\rld!**'))
          ).to eq("<b>Hello, <i>Wo</i>rld!</b>")

        expect(
          replace_with_italic(replace_with_bold("**\\\\Hello, World!\\\\**"))
          ).to eq("<b><i>Hello, World!</i></b>")

        expect(
          replace_with_italic(replace_with_bold("\\\\**Hello, World!**\\\\"))
          ).to eq("<i><b>Hello, World!</b></i>")
      end
    end

  end

  describe "finding parent URI" do
    it "should return root directory" do
      expect(parent_uri "/").to eq "/"
    end

    it "should return root directory" do
      expect(parent_uri "/name1").to eq "/"
    end

    it "should cut the last part off" do
      expect(parent_uri "/name1/name2").to eq "/name1/"
    end
  end
end
