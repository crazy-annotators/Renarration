package com.boun.renarration;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hp.hpl.jena.ontology.OntClass;
import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.util.iterator.ExtendedIterator;
import com.mongodb.util.JSON;
import com.renarration.form.Annotation;
import com.renarration.form.Renarration;
import com.renarration.form.User;
import com.renarration.utils.Library;
import com.renarration.utils.Mongo_Util;
/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private static final String renarration_url = "webapps" + File.separator + "renarration";
	private static final String renarration_resources_url = File.separator + "resources";
	private static final String renarration_target_url = File.separator + "resources" + File.separator + "renarrated";
	private static final String renarration_pages_url = File.separator + "resources" + File.separator+ "pages";
	private static final String injection = "<script src=\"http://localhost:8181/renarration/resources/js/injected.js\"></script>";	
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);		
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);		
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "login";
	}
	
	@RequestMapping(value = "/back", method = RequestMethod.GET)
	public String back(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);		
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);		
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}	
	
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String mongoInsertAnnotation(@ModelAttribute User user, RedirectAttributes redirectAttributes, Locale locale, Model model, HttpServletRequest request) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String nameMessage="";
		String emailMessage="";
		String userID="";
		String result = "";	
		User myuser = new User();

		try{		
			if(user.getName().length()<=0){
				nameMessage="Please provide a name!";
			}
			if(user.getEmail().length()<=0){
				emailMessage="Please provide an email!";
			}
			
			// set mongo utils
			Mongo_Util mongoUtil = new Mongo_Util();
			
    		String rootPath = System.getProperty("catalina.home");
    		File dir = new File(rootPath + File.separator + renarration_url + renarration_resources_url);
    		
    		String file_path = dir.getAbsolutePath() + File.separator + "mongo.properties";
    		mongoUtil.setMongoProperties("db_name", file_path);
			
    		//mongoUtil.deleteFromAnnotations("target.source.@id", annotation.getSourceURL());
    		
    		if(mongoUtil.userExists("email", user.getEmail())>0){
    			// user exists
    			User myuser2 = mongoUtil.getUser("email", user.getEmail());
    			myuser.setEmail(myuser2.getEmail());
    			myuser.setName(myuser2.getName());
    			myuser.setUser_id(myuser2.getUser_id());
    		}
    		else{
    			mongoUtil.insertUser("{\"userid\": \""+user.getUser_id()+"\", \"name\": \""+user.getName()+"\", \"email\": \""+user.getEmail()+"\"}");
    			//myuser = new User();
    			myuser.setEmail(user.getEmail());
    			myuser.setName(user.getName());
    			myuser.setUser_id(user.getUser_id());
    		}
			
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		if(nameMessage.length()>0 || emailMessage.length()>0){
			model.addAttribute("nameMessage", nameMessage );
			model.addAttribute("emailMessage", emailMessage );
			return "login";
		}
		else{
			model.addAttribute("result", result);
			request.getSession().setAttribute("name", myuser.getName());
			request.getSession().setAttribute("email", myuser.getEmail());
			request.getSession().setAttribute("userId", myuser.getUser_id());
			return "home";
		}
		
	}
	
	@RequestMapping(value = "/mongoInsertAnnotation", method = RequestMethod.POST)
	public String mongoInsertAnnotation(@ModelAttribute Annotation annotation, RedirectAttributes redirectAttributes, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		String[] tokens = {};
		String listOfAnnotations = "";
		try{		
			Mongo_Util mongoUtil = new Mongo_Util();
			tokens = annotation.getAnnotationText().split("__--__");
			int tokenCount = tokens.length;
			
    		String rootPath = System.getProperty("catalina.home");
    		File dir = new File(rootPath + File.separator + renarration_url + renarration_resources_url);
    		
    		String file_path = dir.getAbsolutePath() + File.separator + "mongo.properties";
    		mongoUtil.setMongoProperties("db_name", file_path);
			
			result = mongoUtil.deleteFromAnnotations("target.source.@id", annotation.getSourceURL());
			
			for(int i=0; i<tokenCount; i++){				
				result = mongoUtil.insertIntoAnnotations(tokens[i]);
			}
			
			//listOfAnnotations = mongoUtil.getAnnotations("hasTarget.hasSource.@id", annotation.getSourceURL());
			
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		redirectAttributes.addAttribute("page", annotation.getSourceURL());
		redirectAttributes.addAttribute("action", "annotate");
		
		model.addAttribute("semanticList", result);
		return "redirect:/url";
	}
	
	@RequestMapping(value = "/mongoInsertRenarration", method = RequestMethod.POST)
	public String mongoInsertRenarration(@ModelAttribute Renarration renarration, RedirectAttributes redirectAttributes, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		String[] tokens = {};
		
		try{		
			Mongo_Util mongoUtil = new Mongo_Util();						
			
    		String rootPath = System.getProperty("catalina.home");
    		File dir = new File(rootPath + File.separator + renarration_url + renarration_resources_url);
    		
    		String file_path = dir.getAbsolutePath() + File.separator + "mongo.properties";
    		mongoUtil.setMongoProperties("db_name", file_path);
			
    		result = mongoUtil.insertIntoRenarration(renarration.getRenarrationText());		
    		
    		
    		// write renarrated page
    		String fileName = renarration.getFileName();
			
    		File dir_rn = new File(rootPath + File.separator + renarration_url + renarration_target_url);
    		
    		String file_path_rn = dir_rn.getAbsolutePath() + File.separator + fileName;
 
			File file = new File(file_path_rn);
			
            if (!dir_rn.exists())
            	dir_rn.mkdirs();
 
			if (!file.exists()) {
				file.createNewFile();
			}
			

 
			//use FileWriter to write file
			FileWriter fw = new FileWriter(file.getAbsoluteFile());
			BufferedWriter bw = new BufferedWriter(fw);
 
			bw.write(renarration.getRenarrationHTML());
 
			bw.close();    		    		
			
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		return "home";
	}	
	
	@RequestMapping(value = "/testMongoInsertAnnotation", method = RequestMethod.GET)
	public String testMongoInsertAnnotation(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		
		try{		
			Mongo_Util mongoUtil = new Mongo_Util();
			
    		String rootPath = System.getProperty("catalina.home");
    		File dir = new File(rootPath + File.separator + renarration_url + renarration_resources_url);
    		
    		String file_path = dir.getAbsolutePath() + File.separator + "mongo.properties";
    		mongoUtil.setMongoProperties("db_name", file_path);
			
			result = mongoUtil.insertIntoRenarrations("{\"abc\":\"EmrahGuder\"}");
			result = result + mongoUtil.getDb_name() + mongoUtil.getMongo_server();
			
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		model.addAttribute("semanticList", result );
		return "testJena";
	}
	
	@RequestMapping(value = "/testMongoDeleteAnnotation", method = RequestMethod.GET)
	public String testMongoDeleteAnnotation(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		
		try{		
			Mongo_Util mongoUtil = new Mongo_Util();
			
			result = mongoUtil.deleteFromAnnotations("hasTarget.hasSource.@id", "http://annotatorjs.org/");
			
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		model.addAttribute("semanticList", result );
		return "testJena";
	}	
	
	@RequestMapping(value = "/getClasses", method = RequestMethod.GET)
	public String getClasses(@RequestParam(value="uri", required=true) String uri, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		String queryString = "";
		
		try{		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(uri);
			//in.close();
			ExtendedIterator classes = m.listClasses();
			
			while (classes.hasNext())
		    {
				OntClass thisClass = (OntClass) classes.next();
				result = result + " " + thisClass.toString();
			}			
			
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		model.addAttribute("semanticList", result);
		return "testJena";
	}
	
	@RequestMapping(value = "/getClassesAjaxPost", method = RequestMethod.GET)
	public @ResponseBody String getClassesAjaxPost(@RequestParam(value="ont", required=true) String ont, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "<select id=\"ont_class\" onchange=\"enableDiv('ontology_classes_definition');\"> "
				+ "<option value=\"\"></option>";
		
		try{		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			//in.close();
			ExtendedIterator classes = m.listClasses();
			
			while (classes.hasNext())
		    {
		      OntClass thisClass = (OntClass) classes.next();		      
		      result = result + "<option value=\""+thisClass.toString()+"\">" + thisClass.toString() + "</option>";	   
		     
		    }
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		return result + "</select>";
	}
	
	@RequestMapping(value = "/getClassesAjaxPostDBpedia", method = RequestMethod.GET)
	public @ResponseBody String getClassesAjaxPostDBpedia(@RequestParam(value="ont", required=true) String ont, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "Object Class Type : <select id=\"ont_class_dbpedia\" onchange=\"getDataPropertiesAjaxPostDBpedia();\">";
		
		try{		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			//in.close();
			ExtendedIterator classes = m.listClasses();
			
			while (classes.hasNext())
		    {
		      OntClass thisClass = (OntClass) classes.next();		      
		      result = result + "<option value=\""+thisClass.toString()+"\">" + thisClass.toString() + "</option>";	   
		     
		    }
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		return result + "</select>";
	}	
	
	@RequestMapping(value = "/queryDBpedia", method = RequestMethod.GET)
	public @ResponseBody String queryDBpedia(@RequestParam(value="data_type", required=true) String data_type, @RequestParam(value="object_type", required=true) String object_type, @RequestParam(value="regex", required=true) String regex, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "DBpedia Resource &nbsp;: <select id=\"dbpedia_result\">";
		String queryString = "";
		
		try{
		
			//OntModel m = ModelFactory.createOntologyModel();
			//m.read(ont);
			
			queryString = "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
						+ "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> "
						+ "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
						+ "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
						+ "PREFIX foaf: <http://xmlns.com/foaf/0.1/> "
						+ "PREFIX : <http://dbpedia.org/resource/> "
						+ "PREFIX dc: <http://purl.org/dc/elements/1.1/> "
						+ "PREFIX dbpedia2: <http://dbpedia.org/property/> "
						+ "PREFIX dbpedia: <http://dbpedia.org/> "
						+ "PREFIX skos: <http://www.w3.org/2004/02/skos/core#> " 
					    + "SELECT distinct ?s "
					    + "WHERE { "
					    + "?s <"+data_type+"> ?o . "
					    + "?s rdf:type <"+object_type+"> . "
					    + "FILTER (regex(?o, \""+regex+"\", \"i\")) "
					    + "} ORDER BY ?s";		
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.sparqlService("http://dbpedia.org/sparql", query);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					//Literal name = 
					result = result + "<option value=\""+soln.getResource("s").toString()+"\">" + soln.getResource("s").toString() + "</option>";
				}

		}
		catch(Exception ex){
			result = ex.getMessage();
		}

		
		model.addAttribute("semanticList", result);
		model.addAttribute("query", queryString);
		return result + "</select>";
	}
	
	@RequestMapping(value = "/getReferenceDataFromDBPedia", method = RequestMethod.GET)
	public @ResponseBody String getReferenceDataFromDBPedia(@RequestParam(value="resource", required=true) String resource, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		String queryString = "";
		
		try{
		
			//OntModel m = ModelFactory.createOntologyModel();
			//m.read(ont);
			
			queryString = "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
						+ "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> "
						+ "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
						+ "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
						+ "PREFIX foaf: <http://xmlns.com/foaf/0.1/> "
						+ "PREFIX : <http://dbpedia.org/resource/> "
						+ "PREFIX dc: <http://purl.org/dc/elements/1.1/> "
						+ "PREFIX dbpedia2: <http://dbpedia.org/property/> "
						+ "PREFIX dbpedia: <http://dbpedia.org/> "
						+ "PREFIX skos: <http://www.w3.org/2004/02/skos/core#> " 
					    + "SELECT distinct ?abstract "
					    + "WHERE { "
					    + "<" + resource + "> <http://dbpedia.org/ontology/abstract> ?abstract "
					    + "FILTER langMatches(lang(?abstract), \"en\") "
					    + "}";		
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.sparqlService("http://dbpedia.org/sparql", query);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					
					result = result + soln.getLiteral("abstract");							
				}

		}
		catch(Exception ex){
			result = ex.getMessage();
		}

		return result;
	}	
	
	@RequestMapping(value = "/queryDBpediaType", method = RequestMethod.GET)
	public @ResponseBody String queryDBpediaType(@RequestParam(value="data_type", required=true) String data_type, @RequestParam(value="regex", required=true) String regex, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "Type Of Resource &nbsp;: <select id=\"dbpedia_type_result\" onchange=\"QueryDBPedia();\">";
		String queryString = "";
		
		try{
		
			//OntModel m = ModelFactory.createOntologyModel();
			//m.read(ont);
			
			queryString = "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
						+ "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> "
						+ "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
						+ "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
						+ "PREFIX foaf: <http://xmlns.com/foaf/0.1/> "
						+ "PREFIX : <http://dbpedia.org/resource/> "
						+ "PREFIX dc: <http://purl.org/dc/elements/1.1/> "
						+ "PREFIX dbpedia2: <http://dbpedia.org/property/> "
						+ "PREFIX dbpedia: <http://dbpedia.org/> "
						+ "PREFIX skos: <http://www.w3.org/2004/02/skos/core#> " 
					    + "SELECT distinct ?type "
					    + "WHERE { "
					    + "?s <"+data_type+"> ?o . "
					    + "?s rdf:type ?type . "
					    + "FILTER (regex(?o, \""+regex+"\", \"i\")) "
					    + "} ORDER BY ?type";		
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.sparqlService("http://dbpedia.org/sparql", query);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					//Literal name = 
					result = result + "<option value=\""+soln.getResource("type").toString()+"\">" + soln.getResource("type").toString() + "</option>";
				}

		}
		catch(Exception ex){
			result = ex.getMessage();
		}

		
		model.addAttribute("semanticList", result);
		model.addAttribute("query", queryString);
		return result + "</select>";
	}	
	
	@RequestMapping(value = "/getProperties", method = RequestMethod.GET)
	public String getProperties(@RequestParam(value="ont", required=true) String ont, @RequestParam(value="ont_class", required=true) String ont_class, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		String queryString = "";
		
		try{
		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			
			queryString = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
					+ "SELECT distinct ?property where { "
					+ "{ ?property rdfs:domain ?class . <"+ont_class.trim()+"> rdfs:subClassOf ?class . } "
					+ "UNION "
					+ "{ ?property rdfs:domain <"+ ont_class.trim()+"> } }";		
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.create(query, m);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					//Literal name = 
					result = result + " " + soln.getResource("property").toString();
				}


			

		}
		catch(Exception ex){
			result = ex.getMessage();
		}

		
		model.addAttribute("semanticList", result);
		model.addAttribute("query", queryString);
		return "testJena";
	}	
	
	@RequestMapping(value = "/getDataPropertiesAjaxPost", method = RequestMethod.GET)
	public @ResponseBody String getDataPropertiesAjaxPost(@RequestParam(value="ont", required=true) String ont, @RequestParam(value="ont_class", required=true) String ont_class, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "<select id=\"ont_data_property1\"><option value=\"\"></option>";
		String result2 = "<select id=\"ont_data_property2\"><option value=\"\"></option>";
		String queryString = "";
		String input_type1 = "<input type=\"text\" id=\"ont_data_value1\">";
		String input_type2 = "<input type=\"text\" id=\"ont_data_value2\">";
		
		try{
		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			
			queryString = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
				    + "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
				    + "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
					+ "SELECT distinct ?property where { "
					+ "{ ?property a rdf:Property . ?property rdfs:domain ?class . <"+ ont_class.trim()+"> rdfs:subClassOf ?class . } "
					+ "UNION "
					+ "{ ?property a rdf:Property . ?property rdfs:domain <"+ ont_class.trim()+"> } "
					+ "UNION "
					+ "{ ?property a rdf:Property . ?property rdfs:domain owl:Thing } "					
					+ "}";		
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.create(query, m);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					result = result + "<option value=\""+soln.getResource("property").toString()+"\">" + soln.getResource("property").toString().replace("http://xmlns.com/foaf/0.1/", "") + "</option>";
					result2 = result2 + "<option value=\""+soln.getResource("property").toString()+"\">" + soln.getResource("property").toString().replace("http://xmlns.com/foaf/0.1/", "") + "</option>";
				}
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		
		
		return result + "</select> " + input_type1 +"<br>" + result2 + "</select> " + input_type2;
	}
	
	@RequestMapping(value = "/getDataPropertiesAjaxPostDBpedia", method = RequestMethod.GET)
	public @ResponseBody String getDataPropertiesAjaxPostDBpedia(@RequestParam(value="ont", required=true) String ont, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "Object Data Type &nbsp;: <select id=\"ont_data_property_dbpedia\" onchange=\"enableDiv('regex_dbpedia');\">";
		String queryString = "";
		if(ont.contains("dbpedia.org/ontology")){
			try{
				
				//OntModel m = ModelFactory.createOntologyModel();
				//m.read(ont);
				
				queryString = "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
							+ "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> "
							+ "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
							+ "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
							+ "PREFIX foaf: <http://xmlns.com/foaf/0.1/> "
							+ "PREFIX : <http://dbpedia.org/resource/> "
							+ "PREFIX dc: <http://purl.org/dc/elements/1.1/> "
							+ "PREFIX dbpedia2: <http://dbpedia.org/property/> "
							+ "PREFIX dbpedia: <http://dbpedia.org/> "
							+ "PREFIX skos: <http://www.w3.org/2004/02/skos/core#> " 
						    + "SELECT distinct ?property "
						    + "WHERE { "
						    + "?property a rdf:Property . "
						    + "FILTER (regex(?property, \"http://dbpedia.org/ontology/\",\"i\")) . "
						    + "} ORDER BY ?property";		
				
				Query query = QueryFactory.create(queryString);
				QueryExecution qexec = QueryExecutionFactory.sparqlService("http://dbpedia.org/sparql", query);

					ResultSet results = qexec.execSelect();
					while(results.hasNext()){
						QuerySolution soln = results.nextSolution();
						//Literal name = 
						result = result + "<option value=\""+soln.getResource("property").toString()+"\">" + soln.getResource("property").toString().substring(28) + "</option>";
					}

			}
			catch(Exception ex){
				result = ex.getMessage();
			}
		}
		else
		{
			try{
			
				OntModel m = ModelFactory.createOntologyModel();
				m.read(ont);
				
				queryString = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
					    + "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
					    + "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
						+ "SELECT distinct ?property where { "
						+ "{ ?property rdf:type owl:DatatypeProperty } "
						+ "UNION "
						+ "{ ?property rdf:type owl:ObjectProperty } "	
						//+ "UNION "
						//+ "{ ?property rdf:type rdf:Property } "					
						+ "}";
				
				Query query = QueryFactory.create(queryString);
				QueryExecution qexec = QueryExecutionFactory.create(query, m);
	
					ResultSet results = qexec.execSelect();
					while(results.hasNext()){
						QuerySolution soln = results.nextSolution();
						result = result + "<option value=\""+soln.getResource("property").toString()+"\">" + soln.getResource("property").toString() + "</option>";
					}
			}
			catch(Exception ex){
				result = ex.getMessage();
			}
		}
		return result + "</select>";
	}	
	
	@RequestMapping(value = "/getObjectPropertiesAjaxPost", method = RequestMethod.GET)
	public @ResponseBody String getObjectPropertiesAjaxPost(@RequestParam(value="ont", required=true) String ont, @RequestParam(value="ont_class", required=true) String ont_class, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "<select id=\"ont_object_property\" onchange=\"getObjectClassesAjaxPost();\">";
		String queryString = "";
		
		try{
		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			
			queryString = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
				    + "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
				    + "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
					+ "SELECT distinct ?property where { "
					+ "{ ?property rdf:type owl:ObjectProperty . ?property rdfs:domain ?class . <"+ ont_class.trim()+"> rdfs:subClassOf ?class . } "
					+ "UNION "
					+ "{ ?property rdf:type owl:ObjectProperty . ?property rdfs:domain <"+ ont_class.trim()+"> } }";		
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.create(query, m);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					result = result + "<option value=\""+soln.getResource("property").toString()+"\">" + soln.getResource("property").toString().replace("http://xmlns.com/foaf/0.1/", "") + "</option>";
				}
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		return "Relationship : " + result + "</select>";
	}	
	
	@RequestMapping(value = "/getObjectClassesAjaxPost", method = RequestMethod.GET)
	public @ResponseBody String getObjectClassesAjaxPost(@RequestParam(value="ont", required=true) String ont, @RequestParam(value="ont_class", required=true) String ont_class, @RequestParam(value="object_property", required=true) String object_property, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "<select id=\"related_object_class\" onchange=\"getDomainAndRange();\"><option value=\"\"></option>";
		String queryString = "";
		
		try{
		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			
			queryString = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
				    + "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
				    + "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
					+ "SELECT distinct ?class where { "
					+ "?property rdf:type owl:ObjectProperty . ?property rdfs:range ?class . FILTER (?property = <"+object_property+">)"
					+ " }";				
			
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.create(query, m);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();					
						result = result + "<option value=\""+soln.getResource("class").toString()+"\">" + soln.getResource("class").toString().replace("http://xmlns.com/foaf/0.1/", "") + "</option>";
				}
		}
		catch(Exception ex){
			result = ex.getMessage();
		}
		
		return "Object : " + result + "</select>";
	}		
	
	@RequestMapping(value = "/getObjectProperties", method = RequestMethod.GET)
	public String getObjectProperties(@RequestParam(value="ont", required=true) String ont, @RequestParam(value="ont_class", required=true) String ont_class, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		String result = "";
		String queryString = "";
		
		try{
		
			OntModel m = ModelFactory.createOntologyModel();
			m.read(ont);
			
			queryString = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
					    + "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> "
					    + "PREFIX owl: <http://www.w3.org/2002/07/owl#> "
					    + "SELECT distinct ?property where { "
					    + "?property rdf:type owl:ObjectProperty . ?property rdfs:domain <" + ont_class.trim()+"> . } ";		
			 
			Query query = QueryFactory.create(queryString);
			QueryExecution qexec = QueryExecutionFactory.create(query, m);

				ResultSet results = qexec.execSelect();
				while(results.hasNext()){
					QuerySolution soln = results.nextSolution();
					//Literal name = 
					result = result + " " + soln.getResource("property").toString();
				}


			

		}
		catch(Exception ex){
			result = ex.getMessage();
		}

		
		model.addAttribute("semanticList", result);
		model.addAttribute("query", queryString);
		return "testJena";
	}	
	
	@RequestMapping(value = "/serv", method = RequestMethod.GET)
	public String url(@RequestParam(value="page", required=true) String page, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		 String list = "";
		 String result = "Renarrations for the Web resource requested : <br>";
		 String token0="";
		 String token1="";
		 String token2="";
		try {	
			Document doc = null;
			Mongo_Util mongoUtil = new Mongo_Util();
			
    		String rootPathMongo = System.getProperty("catalina.home");
    		File dirMongo = new File(rootPathMongo + File.separator + renarration_url + renarration_resources_url);
    		
    		String filePathMongo = dirMongo.getAbsolutePath() + File.separator + "mongo.properties";
    		mongoUtil.setMongoProperties("db_name", filePathMongo);
			
    		list = mongoUtil.getRenarratedList("source.@id", page);
    		
    		
	
		} catch (Exception e) {
		e.printStackTrace();
		}
	
		model.addAttribute("list", list);
	
		return "serv";
	}	

	@RequestMapping(value = "/url", method = RequestMethod.GET)
	public String url(@RequestParam(value="page", required=true) String page, @RequestParam(value="action", required=true) String action, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		URL url;
		String listOfAnnotations = "";
		 
		try {			
			
			Document doc = null;
			Mongo_Util mongoUtil = new Mongo_Util();
			
    		String rootPathMongo = System.getProperty("catalina.home");
    		File dirMongo = new File(rootPathMongo + File.separator + renarration_url + renarration_resources_url);
    		
    		String filePathMongo = dirMongo.getAbsolutePath() + File.separator + "mongo.properties";
    		mongoUtil.setMongoProperties("db_name", filePathMongo);
			
			listOfAnnotations = mongoUtil.getAnnotations("target.source.@id", page);
			
			try {
				String content = Library.getText(page);
		        doc = Jsoup.parse(content, page);
		        //Jsoup.connect(page).get();
		    } catch (IOException e1) {
		        e1.printStackTrace();
		    }

		    Elements images = doc.select("img[src]");	
		    
		    for (Element element : images) {
		        //System.out.println("\n"+link.attr("href"));
		        //System.out.println(link.attr("abs:href"));

		        if(element.attr("src").startsWith("http:")){
		            //Do nothing for now
		        	
		        }
		        else{
		        	element.attr("src", element.absUrl("src"));
		            //s = s.replaceAll(element.attr("src"), element.absUrl("src"));
		        }
		    }
		    
		    Elements links = doc.select("link[href]");
		    for (Element element : links) {
		        //System.out.println("\n"+link.attr("href"));
		        //System.out.println(link.attr("abs:href"));

		        if(element.attr("href").startsWith("http:")){
		            //Do nothing for now
		        	
		        }
		        else{	
		        	element.attr("href", element.absUrl("href"));
		            //s = s.replaceAll(element.attr("href"), element.absUrl("href"));
		        }
		    }
		    
		    Elements a_links = doc.select("a[href]");
		    for (Element element : a_links) {
		        //System.out.println("\n"+link.attr("href"));
		        //System.out.println(link.attr("abs:href"));

		        if(element.attr("href").startsWith("http:")){
		            //Do nothing for now
		        	
		        }
		        else{
		        	element.attr("href", element.absUrl("href"));
		            //s = s.replaceAll(element.attr("href"), element.absUrl("href"));
		        }
		    }
		    //System.out.println(s);
		    String s = doc.toString();
		     
			String fileName = "current_page.html";
			
    		String rootPath = System.getProperty("catalina.home");
    		File dir = new File(rootPath + File.separator + renarration_url + renarration_pages_url);
    		
    		String file_path = dir.getAbsolutePath() + File.separator + fileName;
 
			File file = new File(file_path);
			
            if (!dir.exists())
                dir.mkdirs();
 
			if (!file.exists()) {
				file.createNewFile();
			}
			

 
			//use FileWriter to write file
			FileWriter fw = new FileWriter(file.getAbsoluteFile());
			BufferedWriter bw = new BufferedWriter(fw);
 
			bw.write(s);
			bw.write(injection);
 
			bw.close();
 
			System.out.println("Done");
			
			model.addAttribute("current_page", page);
			model.addAttribute("listOfAnnotations", listOfAnnotations);
 
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//model.addAttribute("serverTime", formattedDate );
		
		return action;
	}	
	
	@RequestMapping(value = "/url2", method = RequestMethod.GET)
	public String url2(@RequestParam(value="page", required=true) String page, Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
	 
		try {			
			
			Document doc = null;
			
			
			
			try {
		        doc = Jsoup.connect(page).get();
		    } catch (IOException e1) {
		        e1.printStackTrace();
		    }

		    Elements images = doc.select("img[src]");
		    String s = doc.toString();
		    for (Element element : images) {
		        //System.out.println("\n"+link.attr("href"));
		        //System.out.println(link.attr("abs:href"));

		        if(element.attr("src").equalsIgnoreCase("/")){
		            //Do nothing for now
		        }
		        else{
		        	
		            s = s.replaceAll(element.attr("src"), element.absUrl("src"));
		        }
		    }
		    
		    Elements links = doc.select("link[href]");
		    for (Element element : links) {
		        //System.out.println("\n"+link.attr("href"));
		        //System.out.println(link.attr("abs:href"));

		        if(element.attr("href").equalsIgnoreCase("/")){
		            //Do nothing for now
		        }
		        else{
		        	
		            s = s.replaceAll(element.attr("href"), element.absUrl("href"));
		        }
		    }
		    
		    Elements a_links = doc.select("a[href]");
		    for (Element element : a_links) {
		        //System.out.println("\n"+link.attr("href"));
		        //System.out.println(link.attr("abs:href"));

		        if(element.attr("href").equalsIgnoreCase("/")){
		            //Do nothing for now
		        }
		        else{
		        	
		            s = s.replaceAll(element.attr("href"), element.absUrl("href"));
		        }
		    }
		    //System.out.println(s);
		     
			String fileName = "current_page.html";
			
    		String rootPath = System.getProperty("catalina.home");
    		File dir = new File(rootPath + File.separator + renarration_url + renarration_pages_url);
    		
    		String file_path = dir.getAbsolutePath() + File.separator + fileName;
 
			File file = new File(file_path);
			
            if (!dir.exists())
                dir.mkdirs();
 
			if (!file.exists()) {
				file.createNewFile();
			}
			

 
			//use FileWriter to write file
			FileWriter fw = new FileWriter(file.getAbsoluteFile());
			BufferedWriter bw = new BufferedWriter(fw);
 
			bw.write(s);
			bw.write(injection);
 
			bw.close();
 
			System.out.println("Done");
			
			model.addAttribute("current_page", page);
 
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
}
